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
    let view = UIView()
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
    imageView.alpha = 0.87
    view.addSubview(imageView)
    
    imageView.centerY(in: view)
    imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
    
    view.addSubview(emailTextField)
    emailTextField.centerY(in: view)
    emailTextField.anchor(left: imageView.rightAnchor,
                          bottom: view.bottomAnchor,
                          right: view.rightAnchor,
                          paddingLeft: 8,
                          paddingBottom: 8)
    
    let separatorView = UIView()
    separatorView.backgroundColor = .lightGray
    view.addSubview(separatorView)
    separatorView.anchor(left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         height: 0.75)
    
    return view
  }()
  
  private let emailTextField: UITextField = {
    let textfield = UITextField()
    
    textfield.borderStyle = .none
    textfield.font = UIFont.systemFont(ofSize: 16)
    textfield.textColor = .white
    textfield.keyboardAppearance = .dark
    textfield.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
    return textfield
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    
    view.addSubview(titleLabel)
    titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
    titleLabel.centerX(in: view)
    
    view.addSubview(emailContainerView)
    emailContainerView.anchor(top: titleLabel.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 40,
                              paddingLeft: 15,
                              paddingRight: 15,
                              height: 50)
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
