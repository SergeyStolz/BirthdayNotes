//
//  BirthdayCellViewModel.swift
//  Birthday Notes
//
//  Created by mac on 06.10.2021.
//

import UIKit

struct BirthdayCellViewModel {
    var id = ""
    var name = ""
    var surname = ""
    var birthdayDate = Date()
    
     init(_ items: RealmModel) {
        self.id = items.id
        self.name = items.name
        self.surname = items.surname
        self.birthdayDate = items.birthdayDate
    }
}
