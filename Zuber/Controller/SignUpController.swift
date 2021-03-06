//
//  SignUpController.swift
//  Zuber
//
//  Created by Carlos on 27/08/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private var location = LocationHandler.shared.locationManager.location
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZUBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textfield: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textfield(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textfield: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textfield(withPlaceholder: "Fullname",
                                       isSecureTextEntry: false)
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textfield: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textfield(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedControl.backgroundColor = .backgroundColor
        segmentedControl.tintColor = UIColor(white: 1, alpha: 0.87)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let signupButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                     NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Log In",
                                                         attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                                      NSMutableAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        let accountType = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print("Failed to register user with error: \(error.localizedDescription)")
                return
            }
                
            guard let uid = result?.user.uid else { return }
            let values: [String: Any] = ["email": email, "fullname": fullname, "accountType": accountType]
            
            if accountType == 1 {
                guard let location = self.location else { return }
                let geofire = GeoFire(firebaseRef: driverLocationsDb)
                geofire.setLocation(location, forKey: uid) { (error) in
                    self.updateUserData(uid: uid, values: values)
                }
            }
            
            self.updateUserData(uid: uid, values: values)
        })
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    private func updateUserData(uid: String, values: [String: Any]) {
        usersDb.child(uid).updateChildValues(values) { (error, ref) in
            self.navigationController?.present(HomeController(), animated: true, completion: nil)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(in: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signupButton
                                                   ])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(in: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
}
