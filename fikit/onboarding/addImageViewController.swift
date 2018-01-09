//
//  addImageViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2018-01-09.
//

import UIKit
import Firebase
import FirebaseStorage

class addImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var dataModel = DataModel()
    let picker = UIImagePickerController()

    // Error message
    @IBOutlet weak var missingImage: UILabel!
    
    // Display the chosen image
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    
    // Variable to store chosen image
    var chosenImage: UIImage?

    // Adding profile picture from camera roll
    @IBAction func addImage(_ sender: Any) {
        changeImage()
        
        missingImage.isHidden = true
    }
    
    
    @IBAction func imageOne(_ sender: Any) {
        missingImage.isHidden = true
        chosenImage = UIImage(named: "johnny_cake")
        displayImage.image = chosenImage
    }
    
    @IBAction func imageTwo(_ sender: Any) {
        missingImage.isHidden = true
        chosenImage = UIImage(named: "julia_cake")
        displayImage.image = chosenImage
    }
    
    @IBAction func imageThree(_ sender: Any) {
        missingImage.isHidden = true
        chosenImage = UIImage(named: "ryan_cake")
        displayImage.image = chosenImage
    }
    
    @IBAction func toAddBio(_ sender: Any) {
        if chosenImage != nil{
            //Add image to database too
            self.uploadImageToStorage(){url in
                if url != nil {
                }
            }
        
            let viewController:UIViewController = UIStoryboard(name: "onboarding", bundle: nil).instantiateViewController(withIdentifier: "addBio") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }else{
            missingImage.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        missingImage.isHidden = true
        
        // Making images to circles
        displayImage.layer.masksToBounds = false
        displayImage.layer.cornerRadius = displayImage.frame.height/2
        displayImage.clipsToBounds = true
        
        buttonOne.layer.cornerRadius = 0.5 * buttonOne.bounds.size.width
        buttonOne.clipsToBounds = true
        
        buttonTwo.layer.cornerRadius = 0.5 * buttonTwo.bounds.size.width
        buttonTwo.clipsToBounds = true
        
        buttonThree.layer.cornerRadius = 0.5 * buttonThree.bounds.size.width
        buttonThree.clipsToBounds = true
    }
    
    // Change profile image
    func changeImage(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    // Image picker controller and cancle
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        displayImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageToStorage(completion: @escaping (_ url: String?) -> Void) {
        if let currentUser = Auth.auth().currentUser{
            let userID = currentUser.uid
            let userImageRef = dataModel.storageRef.child("image/\(userID).jpg")

            if let uploadData = UIImagePNGRepresentation(chosenImage!) {
                userImageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("error")
                        completion(nil)
                    } else {
                        completion((metadata?.downloadURL()?.absoluteString)!)
                    }
                }
            }

        }
        
    }

}
