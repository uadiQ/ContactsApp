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
    private init() {
        generateStartUpData()
        compileDataBase()
    }
    
    var allContacts: [Contact] = [] {
        didSet {
        //resetDataSource()
        //NotificationCenter.default.post(name: .contactsArrayChanged, object: nil)  -- ошибка связана(наверное), с тем, что при генерации данных при ините
        }
    }
    var datasource: [String: [Contact]] = [:]
    var lettersArray: [String] = []
    
    func contactsByLetter(_ letter: String) -> [Contact] {
        return datasource[letter] ?? []
    }
    
    func addContact(_ contact: Contact) {
        allContacts.append(contact)
        resetDataSource()
    }
    
    func changeContactDetails(_ contact: Contact) {
        guard let editingIndex = getIndex(of: contact, in: allContacts) else { fatalError("Contact index is lost") }
        allContacts[editingIndex] = contact
        resetDataSource()
        NotificationCenter.default.post(name: .ContactChanged, object: nil)
    }
    
    func deleteContact(_ contact: Contact) {
        let sectionLetter = contact.getFirstLetter()
        var contactsOfLetter = contactsByLetter(sectionLetter)
        guard !contactsOfLetter.isEmpty else { return }
        guard let deletingIndex = getIndex(of: contact, in: contactsOfLetter) else { return }
        contactsOfLetter.remove(at: deletingIndex)
        if contactsOfLetter.isEmpty {
            datasource[sectionLetter] = nil
        } else {
            datasource[sectionLetter] = contactsOfLetter
        }
        updateLettersArray()
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
     func resetDataSource() {
        datasource = [:]
        compileDataBase()
    }
    
    // MARK: - private methods
    
    private func generateStartUpData() {
        allContacts.append(Contact(name: "Thor", surname: "Odinson", number: "777-777-77", email: "Th0r@asgard.com", pic: #imageLiteral(resourceName: "thor")))
        allContacts.append(Contact(name: "Odin", number: "111"))
        allContacts.append(Contact(name: "Hulk", surname: "Banner", number: "He smashed his phone =/"))
        allContacts.append(Contact(name: "Groot", number: "4357801"))
        allContacts.append(Contact(name: "Rocket", number: "123-321-41"))
        allContacts[4].setProfilePic(image: #imageLiteral(resourceName: "Rocket"))
        allContacts.append(Contact(name: "Thanos", number: "411-50547"))
    }
    
    private func compileDataBase() {
        datasource = [:]
        for contact in allContacts {
            let contactKey = contact.getFirstLetter()
            var tempContactArray = datasource[contactKey] ?? []
            tempContactArray.append(contact)
            datasource[contactKey] = tempContactArray
        }
        updateLettersArray()
    }
    
    private func getIndex(of contact: Contact, in contactsArray: [Contact]) -> Int? {
        var contactIndex: Int?
        for (index, item) in contactsArray.enumerated() where item.id == contact.id {
                contactIndex = index
                break
        }
        return contactIndex
    }
    
    private func updateLettersArray() {
        lettersArray = Array(datasource.keys)
        lettersArray.sort()
    }
    
    func getContact(indexPath: IndexPath) -> Contact? {
        let contactKey = lettersArray[indexPath.section]
        let contactsForSection = datasource[contactKey]
        return contactsForSection?[indexPath.row]
    }
    
}
