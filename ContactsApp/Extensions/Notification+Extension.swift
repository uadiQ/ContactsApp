//
//  Notification+Extension.swift
//  ContactsApp
//
//  Created by Vadim Shoshin on 12.11.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let ContactChanged = Notification.Name("ContactChanged")
    static let ContactDeleted = Notification.Name("ContactDeleted")
}
