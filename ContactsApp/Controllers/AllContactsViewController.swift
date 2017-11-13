//
//  AllContactsViewController.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class AllContactsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        DataManager.instance.generateStartUpData()
        DataManager.instance.compileDataBase()
        addObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowContactInfo", let destVC = segue.destination as? ContactDetailsViewController
            else { return }
        
        guard let cell = sender as? UITableViewCell
            else { return }
        
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        guard let item = DataManager.instance.getContact(indexPath: indexPath) else { return }
        destVC.contactToLoad = item
        
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contactChanged), name: .ContactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactDeleted), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactsArrayChanged), name: .contactsArrayChanged, object: nil)
    }
}

// MARK: - tableView extensions
extension AllContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = DataManager.instance.lettersArray[section]
        let contactsForSection = DataManager.instance.datasource[key] ?? []
        return contactsForSection.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.instance.datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataManager.instance.lettersArray[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as? ContactTableViewCell
            else { fatalError("Cell with wrong identifier") }
        
        guard let item = DataManager.instance.getContact(indexPath: indexPath) else { fatalError("Contact with wrong indexPath") }
        cell.update(item)
        return cell
    }
}

// MARK: - Notification extensions
extension AllContactsViewController {
    @objc func contactChanged() {
        DataManager.instance.resetDataSource()
        tableView.reloadData()
    }
    
    @objc func contactDeleted() {
        tableView.reloadData()
    }
    
    @objc func contactsArrayChanged() {
        tableView.reloadData()
    }
}
