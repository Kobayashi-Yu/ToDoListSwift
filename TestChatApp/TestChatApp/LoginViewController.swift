//
//  LoginViewController.swift
//  TestChatApp
//
//  Created by 小林裕 on 2020/03/28.
//  Copyright © 2020 KobayashiYu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController{
   
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = Auth.auth().currentUser{
            self.signIn()
        }
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        
                        switch errCode {
                        case .userNotFound:
                            self.showAlert("User account not found. Try registering")
                        case .wrongPassword:
                            self.showAlert("Incorrect username/password combination")
                        default:
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                        
                    }
                    return
                }
                assertionFailure("user and error are nil")
                return
            }

            self.signIn()
        })
    }
    
    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func signIn() {
        performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }
    
    
}
