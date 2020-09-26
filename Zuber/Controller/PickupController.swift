//
//  PickupController.swift
//  Zuber
//
//  Created by Carlos on 25/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import UIKit
import MapKit

protocol PickupControllerDelegate: class {
    func didAcceptTrip(_ trip: Trip)
}

class PickupController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private let pickupLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger?"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let acceptTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("ACCEPT TRIP", for: .normal)
        
        return button
    }()
    
    let trip: Trip
    weak var delegate: PickupControllerDelegate?
    
    // MARK: - Lifecycle
    
    init (trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMapView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleAcceptTrip() {
        Service.shared.acceptTrip(trip: trip) { (error, ref) in
            self.delegate?.didAcceptTrip(self.trip)
        }
    }
    
    
    // MARK: - API
    
    // MARK: - Helper Functions
    
    private func configureMapView() {
        guard let pickupCoordinates = trip.pickupCoordinates else { return }
        let region = MKCoordinateRegion(center: pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pickupCoordinates
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16)
        
        view.addSubview(mapView)
        mapView.setDimensions(height: 270, width: 270)
        mapView.layer.cornerRadius = 270 / 2
        mapView.centerX(in: view)
        mapView.centerY(in: view, contant: -200)
        
        view.addSubview(pickupLabel)
        pickupLabel.centerX(in: view)
        pickupLabel.anchor(top: mapView.bottomAnchor, paddingTop: 16)
        
        view.addSubview(acceptTripButton)
        acceptTripButton.anchor(top: pickupLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32, height: 50)
        
    }
    
}
