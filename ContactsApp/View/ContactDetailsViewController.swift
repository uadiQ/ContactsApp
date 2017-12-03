//
//  ContactDetailsViewController.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    @IBOutlet private var contactDetailsView: UIView!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var surnameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var lcButtonsBottomMargins: NSLayoutConstraint!
    var contactToLoad: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2.0
        guard let contact = contactToLoad else {
            profileImage.image = #imageLiteral(resourceName: "defaultContact")
            setupDelegates()
            title = "New Contact"
            return
        }
        setupUI(by: contact)
    }
    
    private func showErrorAlertWithOk(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    private func emailFits(_ email: String) -> Bool {
        if !email.isEmpty && !email.contains("@") {
            showErrorAlertWithOk(title: "Wrong format", message: "email must have '@' character")
            return false
        } else { return true }
    }
    
        private func phoneNumberFits(_ phoneNumber: String) -> Bool {
            let digits = CharacterSet.decimalDigits
            for char in phoneNumber.unicodeScalars {
                if char != "+" && char != "-" && !digits.contains(char) {
                    showErrorAlertWithOk(title: "Wrong format", message: "Phone number can have only digits and +, -")
                    return false
                    break
                }
            }
            return true
        }
    
    private func validateFields(email: String, phoneNumber: String) -> Bool {
                if !emailFits(email) || !phoneNumberFits(phoneNumber) { return false } else {
                    return true
        }
    }
    
    @IBAction func changeImagePressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let imageActionSheet = UIAlertController(title: "Select source", message: "Pick wished option", preferredStyle: .actionSheet)
        imageActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.showErrorAlertWithOk(title: "Error", message: "Camera is not available")
            }
        }))
        imageActionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        imageActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(imageActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newName = nameTextField.text ?? ""
        if newName.isEmpty {
            showErrorAlertWithOk(title: "Error!", message: "Name is empty")
        }
        
        let newSurname = surnameTextField.text ?? ""
        let newPhoneNumber = phoneNumberTextField.text ?? ""
        let newEmail = emailTextField.text ?? ""
        if !validateFields(email: newEmail, phoneNumber: newPhoneNumber) {
            return
        }
        let image = profileImage.image
        
        if let editedContact = contactToLoad {
            editedContact.name = newName
            editedContact.surname = newSurname
            editedContact.phoneNumber = newPhoneNumber
            editedContact.email = newEmail
            editedContact.profilePic = image
            setTitle(by: editedContact)
            DataManager.instance.changeContactDetails(editedContact)
        } else {
            let newContact = Contact(name: newName, surname: newSurname, number: newPhoneNumber, email: newEmail)
            newContact.profilePic = image
            DataManager.instance.addContact(newContact)
        }
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
        setupDelegates()
    }
    
    private func setupDelegates() {
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
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        upSwipeGesture.direction = .up
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        downSwipeGesture.direction = .down
        contactDetailsView.addGestureRecognizer(tapGesture)
        contactDetailsView.addGestureRecognizer(upSwipeGesture)
        contactDetailsView.addGestureRecognizer(downSwipeGesture)
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
    
    @objc private func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    
    @objc private func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        hideKeyboard()
    }
}

// MARK: - ImagePickerDelegate
extension ContactDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
