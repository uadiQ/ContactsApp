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
    
    func contactsByLetter(by letter: String) -> [Contact] {
        return datasource[letter] ?? []
    }
    
    func addContact(_ contact: Contact) {
        allContacts.append(contact)
    }
    
    func changeContactDetails(_ contact: Contact) {
        //TO DO
//
//
//
//
//
//
        NotificationCenter.default.post(name: .ContactChanged, object: nil)
    }
    
    func deleteContact(_ contact: Contact) {
        let sectionLetter = contact.getFirstLetter()
        var contactsOfLetter = contactsByLetter(by: sectionLetter)
        guard !contactsOfLetter.isEmpty else { return }
        guard let deletingIndex = getIndex(of: contact, in: contactsOfLetter) else { return }
        contactsOfLetter.remove(at: deletingIndex)
        datasource[sectionLetter] = contactsOfLetter
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
    func generateStartUpData() {
        allContacts.append(Contact(name: "Thor", surname: "Odinson", number: "777-777-77", pic: #imageLiteral(resourceName: "thor")))
        allContacts.append(Contact(name: "Odin", number: "111"))
        allContacts.append(Contact(name: "Hulk", surname: "Banner", number: "He smashed his phone =/"))
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
        refreshLettersArray(lettersArray)
    }
    
    private func refreshLettersArray(_ array: [String]) {
        for (index, letter) in lettersArray.enumerated() {
            if contactsByLetter(by: letter).isEmpty {
                lettersArray.remove(at: index)
            }
        }
    }
    
    // MARK: - private methods
    private func getIndex(of contact: Contact, in contactsArray: [Contact]) -> Int? {
        var contactIndex: Int?
        for (index, item) in contactsArray.enumerated() {
            if item.id == contact.id {
                contactIndex = index
                break
            }
        }
        return contactIndex
    }
    
    func getContact(indexPath: IndexPath) -> Contact? {
        let contactKey = lettersArray[indexPath.section]
        let contactsForSection = datasource[contactKey]
        return contactsForSection?[indexPath.row]
    }
    
    
    
}
