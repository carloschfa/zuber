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
let tripsDb = db.child("trips")

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
    
    func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = [ "pickupCoordinates": pickupArray, "destinationCoordinates": destinationArray, "state": TripState.requested.rawValue ] as [String : Any]
        
        tripsDb.child(uid).updateChildValues(values,withCompletionBlock: completion)
        
    }
    
    func observeTrips(completion: @escaping (Trip) -> Void) {
        tripsDb.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    func acceptTrip(trip: Trip, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let passengerUid = trip.passengerUid
        else { return }
        
        let values = ["driverUid": uid, "state": TripState.accepted.rawValue] as [String : Any]
        
        tripsDb.child(passengerUid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func observerCurrentTrip(completion: @escaping (Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        tripsDb.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
}
