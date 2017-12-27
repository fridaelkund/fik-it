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

    //MARK: Labels
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions

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
            dataModel.signUp(email: emailTextField.text!, password:passwordTextField.text!) { [weak self] (data: String) in
                //When we have the data we can use it here
                self?.useData(data: data)
            }
        }
    }
    
    //MARK: Functions
    
    //Using the data that we got from the model
    private func useData(data: String) {
        //data can be success or fail depending on if signup was successful or not
        if(data == "Success"){
            
            // --> FIX SO IT LEADS TO RIGHT STORY BOARD
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Not able to sign up", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
