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
        allContacts.append(Contact(name: "Thor", surname: "Odinson", number: "777-777-77", pic: #imageLiteral(resourceName: "thor")))
        allContacts.append(Contact(name: "Odin", number: "111"))
        allContacts.append(Contact(name: "Hulk", number: "He smashed his phone =/"))
        allContacts.append(Contact(name: "Groot", number: "4357801"))
        allContacts.append(Contact(name: "Rocket", number: "123-321-41"))
        allContacts[4].setProfilePic(image: #imageLiteral(resourceName: "Rocket"))
        allContacts.append(Contact(name: "Thanos", number: "411-50547"))
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
