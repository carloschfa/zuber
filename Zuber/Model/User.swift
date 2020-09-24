//
//  User.swift
//  Zuber
//
//  Created by Carlos on 13/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let uid: String
    let fullname: String
    let email: String
    var accountType: AccountType
    var location: CLLocation?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let accountType = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: accountType)!
        } else {
            self.accountType = .driver
        }
    }
}
