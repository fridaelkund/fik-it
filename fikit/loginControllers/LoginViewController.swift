//
//  LoginViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-11.
//
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    //MARK: Labels
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions
    
    //LOGIN WITH FACEBOOK
    @IBAction func facebookLoginAction(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        //Login with chosen permissions
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Facebook login failed: \(error.localizedDescription)")
                return
            }
            
            //Watch for accessToken and save it to accessToken variable when there is one
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Getting access token failed")
                return
            }
            //Save credentials to variable
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Firebase login failed: \(error.localizedDescription)")
                    
                    //Send an alert to the user if login failed
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    //Controlling the OK button on the alert
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                else{
                    print("Facebook and firebase login successfulSuccess", user ?? "no user")
                    //Go to HomeViewController if the login is sucessful
                    let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController

                    self.present(viewController, animated: false, completion: nil)

                }
            })
            
        }
    }
    
    //LOGIN WITH EMAIL AND PASSWORD
    @IBAction func loginAction(_ sender: UIButton) {
        //Check if user has filled in information
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            //User is logged in
            //Let's authenticate and login
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                //If no authentication error
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in with email and password")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
                    
                    self.present(viewController, animated: false, completion: nil)
                    
                } else {
                    
                    //Alert the user that there is an error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

