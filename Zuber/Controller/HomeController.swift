//
//  HomeController.swift
//  Zuber
//
//  Created by Carlos on 08/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let locationInputView = LocationInputActivationView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // signOut()
        checkIfUserIsLoggedIn()
        enableLocationServices()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            navigationController?.setViewControllers([LoginController()], animated: true)
        } else {
            configureUI()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Debug: Error during signout. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        configureMapView()
        
        view.addSubview(locationInputView)
        locationInputView.centerX(in: view)
        locationInputView.setDimensions(height: 50, width: view.frame.width - 64)
        locationInputView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
}

// MARK: - Location Services

extension HomeController: CLLocationManagerDelegate {
    
    private func enableLocationServices() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not Determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Restricted")
        case .authorizedAlways:
            print("Authorized Always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Authorized When in Use")
            locationManager.requestAlwaysAuthorization()
        default:
            print("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        
        
    }
    
    
}
