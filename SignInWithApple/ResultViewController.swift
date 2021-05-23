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

    @IBOutlet private weak var userIdentifierLabel: UILabel!
    @IBOutlet private weak var givenNameLabel: UILabel!
    @IBOutlet private weak var familyNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.dismiss(animated: true, completion: nil)
    }
}
