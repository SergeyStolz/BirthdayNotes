//
//  RealmModel.swift
//  Birthday Notes
//
//  Created by mac on 06.10.2021.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var birthdayDate = Date()
}

