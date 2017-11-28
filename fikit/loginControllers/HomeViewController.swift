//
//  HomeViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-11.
//

import UIKit
import Firebase
import FirebaseAuth


class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Reference to Database
    var ref = Database.database().reference()
    
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        self.profileImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    //Logout action
    @IBAction func logOutAction(_ sender: Any) {
        
        //We can logout if there is a current user logged in
        if let currentUser = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                //Switch view to "SignUp" view
                
                //Set status to offline in database for the user when signed out
                self.ref.child("users").child(currentUser.uid).child("/status").setValue("offline")
            

                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Logout error", error.localizedDescription)
            }
        }
    }
    
    //Choose profile pic - FUNKAR EJ NU
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
            //Add user to database
            self.ref.child("users").child(currentUser.uid).setValue(["username": currentUser.displayName, "status": "online"])

            
            //DISPLAY PROFILE IMAGE
            if currentUser.photoURL != nil {
                let url = NSURL(string:(currentUser.photoURL?.absoluteString)!)
                let data = NSData(contentsOf:url! as URL)
            
                // If data is not null
                if data!.length > 0 {
                    profileImage.image = UIImage(data:data! as Data)
                } else {
                    //SET PLACEHOLDER IMAGE
                    print("placeholder here")
                }
            }
            else {
                print("No image avaliable")
                // SET PLACEHOLDER ???
            }
        }
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUserInfo(){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Josefine Testuser"
        changeRequest?.commitChanges { (error) in
            // ...
            print("committed new changes")
            self.nameLabel.text = changeRequest?.displayName
        }
    }
    
    
  
}

