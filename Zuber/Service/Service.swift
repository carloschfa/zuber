//
//  Service.swift
//  Zuber
//
//  Created by Carlos on 13/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import Firebase
import CoreLocation
import GeoFire

let db = Database.database().reference()
let usersDb = db.child("users")
let driverLocationsDb = db.child("driver-locations")

struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(uid: String, completion: @escaping (User) -> Void) {
        usersDb.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
        
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping (User) -> Void) {
        let geofire = GeoFire(firebaseRef: driverLocationsDb)
        
        driverLocationsDb.observe(.value) { (snapshot) in
            geofire.query(at: location, withRadius: 5000).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(uid: uid) { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
    
}
