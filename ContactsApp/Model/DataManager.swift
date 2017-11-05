//
//  DataManager.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 05.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    var allContacts: [Contact] = []
    var datasource: [String: [Contact]] = [:]
    var lettersArray: [String] = []
    
    func addContact(contact: Contact) {
        allContacts.append(contact)
    }
    
    func generateStartUpData() {
        allContacts.append(Contact(name: "Thor", surname: "Odinson", number: "777-777-77"))
        allContacts[0].setProfilePic(image: #imageLiteral(resourceName: "thor"))
        allContacts.append(Contact(name: "Odin", number: "111"))
        allContacts.append(Contact(name: "Hulk", number: "He smashed his phone =/"))
    }
    
    func compileDataBase() {
        for contact in allContacts {
            let contactKey = contact.getFirstLetter()
            var tempContactArray = datasource[contactKey] ?? []
            tempContactArray.append(contact)
            datasource[contactKey] = tempContactArray
        }
        lettersArray = Array(datasource.keys)
    }

    func getContact(indexPath: IndexPath) -> Contact? {
        let contactKey = lettersArray[indexPath.section]
        let contactsForSection = datasource[contactKey]
        return contactsForSection?[indexPath.row]
    }
}
