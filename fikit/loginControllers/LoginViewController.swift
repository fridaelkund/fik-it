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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions
    
    //Email + password login
    @IBAction func loginAction(_ sender: UIButton) {
        //Check if user has filled in information
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in
            self.alertWindow(title: "Error", message: "Please enter an email and password.")
            
        } else {
            //User is logged in
            //Let's authenticate and login
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                //If no authentication error
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in with email and password")
                    
                    //Go to the FikaView if the login is sucessful
                    self.presentFikaView()
                   
                } else {
                    
                    //Alert the user that there is an error
                    self.alertWindow(title: "Login error", message: (error?.localizedDescription)!)
                    
                }
            }
        }
    }
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPadding(10)
        emailTextField.setRightPadding(10)
        passwordTextField.setLeftPadding(10)
        passwordTextField.setRightPadding(10)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: Private functions
    
    // Alert window
    private func alertWindow(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Present fikaView on login success
    private func presentFikaView(){
        let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    //Facebook login
    //    @IBAction func facebookLoginAction(_ sender: UIButton) {
    //        let fbLoginManager = FBSDKLoginManager()
    //        //Login with chosen permissions
    //        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
    //            if let error = error {
    //                print("Facebook login failed: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            //Watch for accessToken and save it to accessToken variable when there is one
    //            guard let accessToken = FBSDKAccessToken.current() else {
    //                print("Getting access token failed")
    //                return
    //            }
    //            //Save credentials to variable
    //            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
    //
    //            // Perform login by calling Firebase APIs
    //            Auth.auth().signIn(with: credential, completion: { (user, error) in
    //                if let error = error {
    //                    print("Firebase login failed: \(error.localizedDescription)")
    //
    //                    //Send an alert to the user if login failed
    //                    self.alertWindow(title: "Login error", message: error.localizedDescription)
    //                    return
    //                }
    //                else{
    //                    print("Facebook and firebase login successfulSuccess", user ?? "no user")
    //
    //                    //Go to FikaView if the login is sucessful
    //                    self.presentFikaView()
    //
    //                }
    //            })
    //
    //        }
    //    }
    //
}

