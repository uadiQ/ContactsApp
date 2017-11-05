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
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var surnameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    
    var contactToLoad: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contact = contactToLoad else { return }
        title = contact.name + " " + contact.surname
        profileImage.image = contact.profilePic
        nameLabel.text = contact.name
        surnameLabel.text = contact.surname
        phoneNumberLabel.text = contact.phoneNumber
    }

}
