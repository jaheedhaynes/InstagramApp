//
//  ViewController.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/5/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}



class LoginViewController: UIViewController {
    
    @IBOutlet weak var instagramLabel: UILabel!
    
    @IBOutlet weak var instagramImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func clearErrorLabel() {
        errorLabel.text = ""
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("Missing Fields")
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) {[weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text =
                            
                        "\(error.localizedDescription)"
                        self?.errorLabel.textColor = .systemRed
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text =
                        "\(error.localizedDescription)"
                        self?.errorLabel.textColor = .systemRed
                    }
                    
                case .success:
                    
                    DispatchQueue.main.async {
                        
                        self?.navigateToMainView()
                    }
                    
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "MainTabBarController")
    }
    
    
    @IBAction func createAccountActionButton(_ sender: UIButton) {
        
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
            UIView.transition(with: view, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Login", for: .normal)
                self.statusLabel.text = "Don't have an account ? Click"
                self.createAccountButton.setTitle("SIGNUP", for: .normal)
                
            }, completion: nil)
            
        } else {
            UIView.transition(with: view, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Sign Up", for: .normal)
                self.statusLabel.text = "Already have an account ?"
                self.createAccountButton.setTitle("LOGIN", for: .normal)
            }, completion: nil)
        }
    }
}




