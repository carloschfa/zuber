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

private let reuseIdentifier = "LocationTableViewCell"
private let annotationIdentifier = "DriverAnnotation"

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    
    private let locationActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    
    private final let locationInputViewHeight: CGFloat = 200
    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // signOut()
        checkIfUserIsLoggedIn()
        enableLocationServices()
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: uid, completion: { user in
            self.user = user
        })
    }
    
    func fetchDrivers() {
        guard let location = locationManager.location else { return }
        Service.shared.fetchDrivers(location: location, completion: { driver in
            guard let coordinate = driver.location?.coordinate else { return }
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                    guard let driverAnnotation = annotation as? DriverAnnotation else { return false }
                    if driverAnnotation.uid == driver.uid {
                        driverAnnotation.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    return false
                })
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            navigationController?.setViewControllers([LoginController()], animated: true)
        } else {
            configure()
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
    
    private func configure() {
        configureUI()
        fetchUserData()
        fetchDrivers()
    }
    
    private func configureUI() {
        configureMapView()
        
        view.addSubview(locationActivationView)
        locationActivationView.centerX(in: view)
        locationActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        locationActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        locationActivationView.alpha = 0
        locationActivationView.delegate = self
        
        UIView.animate(withDuration: 2.0) {
            self.locationActivationView.alpha = 1
        }
        
        configureTableView()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    private func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationActivationView.alpha = 0
            self.locationInputView.alpha = 1
            self.tableView.frame.origin.y = self.locationInputViewHeight
        }, completion: { _ in
            print("present table view")
        })
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.addSubview(tableView)
    }
    
}


// MARK: - Map Helper Functions

private extension HomeController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping ([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            response.mapItems.forEach { (item) in
                results.append(item.placemark)
            }
            
            completion(results)
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
    
}

// MARK: - Location Services

extension HomeController: CLLocationManagerDelegate {
    
    private func enableLocationServices() {
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
    
}

// MARK: - LocationInputActivationViewDelegate

extension HomeController: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        configureLocationInputView()
    }
    
}

// MARK: - LocationInputViewDelegate

extension HomeController: LocationInputViewDelegate {
    
    func dismissLocationInputView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationActivationView.alpha = 1
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.locationInputView.removeFromSuperview()
        })
    }
    
    func searchDestination(query: String) {
        searchBy(naturalLanguageQuery: query) { (placemarks) in
            self.searchResults = placemarks
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TableViewDelegate

extension HomeController: UITableViewDelegate {
    
}

// MARK: - TableViewDataSource

extension HomeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTableViewCell
        
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
}
