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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }

    private func setupProviderLoginView() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        loginProviderStackView.addArrangedSubview(button)
    }
    
    @objc
    private func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // Checks if the user has an existing account by requesting both an Apple ID and an iCloud keychain password
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    // Checks whether the credential is an Apple ID (ASAuthorizationAppleIDCredential) or a password credential (ASPasswordCredential)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            
            // Store the 'userIdentifier' in the keychain
            saveUserInKeychain(userIdentifier)
            
            // Show the Apple ID credential information in the 'ResultViewController'
            showResultViewController(appleIDCredential: appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "me.jhk.SignInWithApple", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showResultViewController(appleIDCredential: ASAuthorizationAppleIDCredential) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultViewController = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            resultViewController.appleIDCredential = appleIDCredential
            self.present(resultViewController, animated: true, completion: nil)
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
}

