//
//  Contact.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

class Contact {
    var name: String
    var surname: String
    var phoneNumber: String
    var profilePic: UIImage = #imageLiteral(resourceName: "defaultContact")
    
    init() {
        name = "Default name"
        surname = "Default surname"
        phoneNumber = "----------"
    }
    
    init(name: String, number: String) {
        self.name = name
        self.phoneNumber = number
        surname = ""
    }
    
    convenience init(name: String, surname: String, number: String) {
        self.init(name: name, number: number)
        self.surname = surname
    }
    
    convenience init(name: String, surname: String, number: String, pic: UIImage) {
        self.init(name: name, surname: surname, number: number)
        self.profilePic = pic
    }
    
    func editName(name: String) {
        self.name = name
    }
    func setProfilePic(image: UIImage) {
        self.profilePic = image
    }
    
    func getFirstLetter() -> String {
        var firstChar: String
        if let tryChar = self.name.first {
            firstChar = String(tryChar)
        } else { firstChar = "nil" }
        return firstChar
    }
}
