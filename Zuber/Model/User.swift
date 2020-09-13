//
//  User.swift
//  Zuber
//
//  Created by Carlos on 13/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import CoreLocation

struct User {
    let uid: String
    let fullname: String
    let email: String
    let accountType: Int
    var location: CLLocation?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}
