//
//  Service.swift
//  Zuber
//
//  Created by Carlos on 13/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import Firebase

let db = Database.database().reference()
let usersDb = db.child("users")
let driverLocationsDb = db.child("driver-locations")

struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping (User) -> Void) {
        if let uid = currentUid {
            usersDb.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let user = User(dictionary: dictionary)
                completion(user)
            }
        }
    }
    
}
