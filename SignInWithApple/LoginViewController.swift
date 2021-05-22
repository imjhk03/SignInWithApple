//
//  LoginViewController.swift
//  SignInWithApple
//
//  Created by Joohee Kim on 21. 05. 23..
//

import UIKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var loginProviderStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }

    private func setupProviderLoginView() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        loginProviderStackView.addArrangedSubview(button)
    }
    
    @objc
    private func handleAuthorizationAppleIDButtonPress() {
        
    }

}

