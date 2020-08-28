//
//  LoginController.swift
//  Zuber
//
//  Created by Carlos Henrique Antunes on 3/13/20.
//  Copyright © 2020 Carlos Henrique Antunes. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZUBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textfield: emailTextField)
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textfield(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textfield: passwordTextField)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textfield(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(in: view)
        
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        
        emailContainerView.anchor(top: titleLabel.bottomAnchor,
                                  left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  paddingTop: 40,
                                  paddingLeft: 15,
                                  paddingRight: 15,
                                  height: 50)
        
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor,
        left: view.leftAnchor,
        right: view.rightAnchor,
        paddingTop: 16,
        paddingLeft: 15,
        paddingRight: 15,
        height: 50)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
