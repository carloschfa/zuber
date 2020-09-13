//
//  LocationInputView.swift
//  Zuber
//
//  Created by Carlos on 11/09/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LocationInputViewDelegate?
    
    var user: User? {
        didSet {
            self.titleLabel.text = user?.fullname
        }
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Current Location"
        textfield.backgroundColor = .systemGroupedBackground
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.isEnabled = false
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }()
    
    private lazy var destinationLocationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a destination"
        textfield.backgroundColor = .lightGray
        textfield.returnKeyType = .search
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(in: backButton)
        titleLabel.centerX(in: self)
        
        addSubview(startingLocationTextfield)
        startingLocationTextfield.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 40, paddingRight: 40, height: 30)
        
        addSubview(destinationLocationTextfield)
        destinationLocationTextfield.anchor(top: startingLocationTextfield.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 40, paddingRight: 40, height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(in: startingLocationTextfield, leftAnchor: leftAnchor, paddingLeft: 20)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationLocationIndicatorView)
        destinationLocationIndicatorView.centerY(in: destinationLocationTextfield, leftAnchor: leftAnchor, paddingLeft: 20)
        destinationLocationIndicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(linkingView)
        linkingView.centerX(in: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor, bottom: destinationLocationIndicatorView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleBackTap() {
        delegate?.dismissLocationInputView()
    }
    
}
