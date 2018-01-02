//
//  ProfileViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-12-29.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    var dataModel = DataModel()
    let picker = UIImagePickerController()
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editNameField: UITextField!
    
    //MARK: Actions
    
    //change image
    @IBAction func changeImageAction(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    //save changes
    @IBAction func saveChanges(_ sender: Any) {
        updateUserName(newName: editNameField.text!)
    }
    
    //logout action
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Logout error", error.localizedDescription)
        }
        
        //Set status to offline in database for the user when signed out
        dataModel.setStatus(status: "offline")
        
        //Switch view to "login" view
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
        present(vc, animated: true, completion: nil)

    }
    
    
    //MARK: Functions
    
    //image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        //Save profile image to db user
        profileImage.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUserName(newName: String){
        print("new name is", newName)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges { (error) in
            // ...
            print("committed new changes")
        }
    }
    
    
    //TODO:
    //Add function for changing profile image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        if let currentUser = Auth.auth().currentUser {
            
            //Display username
            editNameField.text = currentUser.displayName
            
            //Display profile image
            if currentUser.photoURL != nil {
                let url = NSURL(string:(currentUser.photoURL?.absoluteString)!)
                let data = NSData(contentsOf:url! as URL)
                
                // If data is not null
                if data!.length > 0 {
                    profileImage.image = UIImage(data:data! as Data)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



