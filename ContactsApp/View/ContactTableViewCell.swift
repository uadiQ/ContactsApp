//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibFullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func update(_ contact: Contact) {
        ibImageView.image = contact.profilePic
        ibFullName.text = (contact.name + " " + contact.surname)
    }
}
