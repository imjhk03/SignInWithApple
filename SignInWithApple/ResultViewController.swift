//
//  ResultViewController.swift
//  SignInWithApple
//
//  Created by Joohee Kim on 21. 05. 23..
//

import UIKit
import AuthenticationServices

final class ResultViewController: UIViewController {
    
    var appleIDCredential: ASAuthorizationAppleIDCredential?

    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdentifierLabel.text = KeychainItem.currentUserIdentifier
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fillInResults()
    }
    
    private func fillInResults() {
        if let appleIDCredential = appleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            userIdentifierLabel.text = userIdentifier
            if let givenName = fullName?.givenName {
                givenNameLabel.text = givenName
            }
            if let familyName = fullName?.familyName {
                familyNameLabel.text = familyName
            }
            if let email = email {
                emailLabel.text = email
            }
        }
    }

    @IBAction private func signOutButtonPressed(_ sender: UIButton) {
        KeychainItem.deleteUserIdentifierFromKeychain()
        
        userIdentifierLabel.text = ""
        givenNameLabel.text = ""
        familyNameLabel.text = ""
        emailLabel.text = ""
        
        DispatchQueue.main.async {
            self.showLoginViewController()
        }
    }
}
