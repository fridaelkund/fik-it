//
//  SignUpViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-11.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    //MARK: Labels
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions
    
    //SIGNUP WITH EMAIL
    @IBAction func createAccountAction(_ sender: AnyObject) {
        //Has user typed in email field or is it blank
        if emailTextField.text == "" || self.passwordTextField.text == "" {
            //Lets alert that user needs to enter email and password
            let alertController = UIAlertController(title: "Error", message: "Please enter email and password to sign up", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            //Lets authenticate and create user in firebase
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //--> Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    //Error alerting user that authentication failed
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
