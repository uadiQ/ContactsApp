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
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var searchContactsArray: [Contact] = []
    private var isSearchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        addObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowContactInfo", let destVC = segue.destination as? ContactDetailsViewController
            else { return }
        
        guard let cell = sender as? UITableViewCell
            else { return }
        
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        let item = getContact(for: indexPath)
        destVC.contactToLoad = item
        
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contactChanged), name: .ContactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactDeleted), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactAdded), name: .ContactAdded, object: nil)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func findContacts(by name: String) {
        isSearchActive = !name.isEmpty
        searchContactsArray.removeAll()
        for contact in DataManager.instance.allContacts {
            if contact.fullName.lowercased().contains(name.lowercased()) {
                searchContactsArray.append(contact)
            }
        }
//        var sectionsArray: [Int] = []
//        let size = DataManager.instance.datasource.count
//        for i in 0..<size {
//            sectionsArray.append(i)
//        }
//        let indexSet = IndexSet(sectionsArray)
//        tableView.reloadSections(indexSet, with: .none)
        tableView.reloadData()
    }
    
    private func updateSearchArrayIfNeeded() {
        guard isSearchActive else { return }
        let searchText = searchBar.text ?? ""
        findContacts(by: searchText)
    }
    
    private func getContact(for indexPath: IndexPath) -> Contact {
        let contact: Contact
        if isSearchActive {
            contact = searchContactsArray[indexPath.row]
        } else {
            guard let contactToLoad = DataManager.instance.getContact(indexPath: indexPath) else { fatalError("CContact with wrong indexPath")}
            contact = contactToLoad
        }
        return contact
    }
}

// MARK: - UITableViewDataSource

extension AllContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = DataManager.instance.lettersArray[section]
        let contactsForSection = DataManager.instance.datasource[key] ?? []
        return isSearchActive ? searchContactsArray.count : contactsForSection.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : DataManager.instance.datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? "Search results" : DataManager.instance.lettersArray[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as? ContactTableViewCell
            else { fatalError("Cell with wrong identifier") }
        let item = getContact(for: indexPath)
        cell.update(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = getContact(for: indexPath)
        DataManager.instance.deleteContact(item)
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension AllContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findContacts(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

// MARK: - Notification extensions

extension AllContactsViewController {
    @objc func contactChanged() {
        DataManager.instance.resetDataSource()
        updateSearchArrayIfNeeded()
        tableView.reloadData()
    }
    
    @objc func contactDeleted() {
        updateSearchArrayIfNeeded()
        tableView.reloadData()
    }
    
    @objc func contactAdded() {
        tableView.reloadData()
    }
}
