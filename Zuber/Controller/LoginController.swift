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
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    
    view.addSubview(titleLabel)
    titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
    titleLabel.centerX(in: view)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
