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
    
    //MARK: Properties
    var dataModel = DataModel()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions

    //Sign up action
    @IBAction func createAccountAction(_ sender: AnyObject) {
        //Has user typed in email field or is it blank
        if emailTextField.text == "" || self.passwordTextField.text == "" {
            self.alertWindow(title: "Error", message: "Please enter email and password to sign up")
        } else {
        
            //Lets authenticate and create user in firebase
            dataModel.signUp(email: emailTextField.text!, password:passwordTextField.text!) { [weak self] (data: String) in
                //When we have the data we can use it here
                self?.useData(data: data)
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
    
    //MARK: Private functions
    
    //Using the data that we got from the model
    private func useData(data: String) {
        //data can be success or fail depending on if signup was successful or not
        if(data == "Success"){
            //Add user to database
            dataModel.addUser()

            //SignUp successful - we login (Go to FikaView)
            self.setUpProfile()
            
        }
        else{
            //Signup failed, display alert with error message
            self.alertWindow(title: "SignUp error", message: "Not able to sign up")
        }
    }
    
    //Alert window for this controller
    private func alertWindow(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setUpProfile(){
        let viewController:UIViewController = UIStoryboard(name: "onboarding", bundle: nil).instantiateViewController(withIdentifier: "addName") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    //Go to fikaView if signup is successful (because then we login)
//    private func presentFikaView(){
//        let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
//        self.present(viewController, animated: false, completion: nil)
//    }
}
