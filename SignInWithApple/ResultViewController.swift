//
//  ResultViewController.swift
//  SignInWithApple
//
//  Created by Joohee Kim on 21. 05. 23..
//

import UIKit
import AuthenticationServices

final class ResultViewController: UIViewController {

    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdentifierLabel.text = KeychainItem.currentUserIdentifier
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
