//
//  ResetPasswordViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-11.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: Actions
    
    //Submit email for new password
    @IBAction func submitAction(_ sender: Any) {
        //Needs to bee an email filled in
        if self.emailTextField.text == "" {
            //If not alert user to fill in email
            self.alertWindow(title: "Oops!", message: "Please enter an email.")
            
        } else {
            //If email filled in authenticate with Firebase for a password reset
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
            
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                //Alert used for both success and error message depending on outcome
                self.alertWindow(title: title, message: message)
        
            })
        }
    }
    
    //MARK: Private functions
    
    //Alert
    private func alertWindow(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
}
