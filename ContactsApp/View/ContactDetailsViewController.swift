//
//  ContactDetailsViewController.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    
    @IBOutlet private weak var lcImageViewHeight: NSLayoutConstraint!
    
    var contactToLoad: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contact = contactToLoad else { return }
        title = contact.name + " " + contact.surname
        profileImage.image = contact.profilePic ?? #imageLiteral(resourceName: "defaultContact")
        nameTextField.text = contact.name
        surnameTextField.text = contact.surname
        phoneNumberTextField.text = contact.phoneNumber
        
    }

    @IBAction func savePressed(_ sender: Any) {
        guard let editedContact = contactToLoad else { return }
        let newName = nameTextField.text ?? ""
        guard !newName.isEmpty else { return }
        editedContact.name = newName
        
        let newSurname = surnameTextField.text ?? ""
        guard !newSurname.isEmpty else { return }
        editedContact.surname = newSurname
        
        let newPhoneNumber = phoneNumberTextField.text ?? ""
        guard !newPhoneNumber.isEmpty else { return }
        editedContact.phoneNumber = newPhoneNumber
        DataManager.instance.changeContactDetails(editedContact)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        guard let contact = contactToLoad else { return }
        DataManager.instance.deleteContact(contact)
        navigationController?.popViewController(animated: true)
    }
    
    //    private func setupStartUI() {
    //        nameTextField.isEnabled = false
    //        surnameTextField.isEnabled = false
    //        phoneNumberTextField.isEnabled = false
    //    }
    
}
