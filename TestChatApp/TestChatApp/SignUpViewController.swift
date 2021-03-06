//
//  SignUpViewController.swift
//  TestChatApp
//
//  Created by 小林裕 on 2020/03/28.
//  Copyright © 2020 KobayashiYu. All rights reserved.
//
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    @IBAction func didTapSignUp(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user,error) in
            
            if let error = error{
                if let errCode = AuthErrorCode(rawValue: error._code){
                    switch errCode{
                    case .invalidEmail:
                        self .showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self .showAlert("Email already in use.")
                    default:
                        self.showAlert("Error:\(error.localizedDescription)")
                    }
                }
                return
            }
            self.signIn()
        })
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title:"To Do App",message: message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss",style:UIAlertAction.Style.default,handler: nil))
        self.present(alertController,animated: true,completion:nil)
    }
    
    func signIn(){
        performSegue(withIdentifier: "SignInFormSignUp", sender: nil)
    }
    
    
}
