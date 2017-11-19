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
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var lcImageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var lcButtonsBottomMargins: NSLayoutConstraint!
    var contactToLoad: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contact = contactToLoad else { return }
        setupUI(by: contact)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let editedContact = contactToLoad else { return }
        let newName = nameTextField.text ?? ""
        editedContact.name = newName
        let newSurname = surnameTextField.text ?? ""
        editedContact.surname = newSurname
        let newPhoneNumber = phoneNumberTextField.text ?? ""
        editedContact.phoneNumber = newPhoneNumber
        let newEmail = emailTextField.text ?? ""
        editedContact.email = newEmail
        setTitle(by: editedContact)
        DataManager.instance.changeContactDetails(editedContact)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        guard let contact = contactToLoad else { return }
        DataManager.instance.deleteContact(contact)
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    private func setupUI(by contact: Contact) {
        setTitle(by: contact)
        setupTextFieldsContent(by: contact)
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
    }
    private func setupTextFieldsContent(by contact: Contact) {
        profileImage.image = contact.profilePic ?? #imageLiteral(resourceName: "defaultContact")
        nameTextField.text = contact.name
        surnameTextField.text = contact.surname
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
    }
    
    private func setTitle(by contact: Contact) {
        title = contact.fullName
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ContactDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

// MARK: - Notifications

extension ContactDetailsViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        lcButtonsBottomMargins.constant = keyboardFrame.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        lcButtonsBottomMargins.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
