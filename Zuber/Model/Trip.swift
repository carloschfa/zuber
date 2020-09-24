//
//  Trip.swift
//  Zuber
//
//  Created by Carlos on 24/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import CoreLocation

enum TripState: Int {
    case requested
    case accepted
    case inProgress
    case completed
}

struct Trip {
    var pickupCoordinates: CLLocationCoordinate2D?
    var destinationCoordinates: CLLocationCoordinate2D?
    let passengerUid: String?
    var driverUid: String?
    var state: TripState?
    
    init(passengerUid: String, dictionary: [String: Any]) {
        self.passengerUid = passengerUid
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
            guard let lon = pickupCoordinates[1] as? CLLocationDegrees else { return }
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinates[0] as? CLLocationDegrees else { return }
            guard let lon = destinationCoordinates[1] as? CLLocationDegrees else { return }
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
        
    }
    
}
