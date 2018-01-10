//
//  ResetPasswordViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-11.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
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
                    title = ""
                    message = "Ett mejl med en länk för att ändra lösenord har skickats till dig."
                    self.emailTextField.text = ""
                }
                
                //Alert used for both success and error message depending on outcome
                self.alertWindow(title: title, message: message)
        
            })
        }
    }
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPadding(10)
        emailTextField.setRightPadding(10)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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

//Solution for this here: https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield
extension UITextField {
    //Setting left padding for any text field
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    //Set right padding for any text-field
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


