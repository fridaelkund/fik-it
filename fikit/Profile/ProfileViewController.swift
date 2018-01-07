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
    fileprivate var tableVC: NameTableViewController?
    var userObj: NSDictionary = [:]
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageBtn: UIButton!
    
    //MARK: Actions
    // Change image
    @IBAction func changeImageAction(_ sender: Any) {
        changeImage()
    }
    
    // Logout action
    @IBAction func logoutAction(_ sender: Any) {
        logOut()
    }

    //MARK: Functions
    
    // Add segue to embedded tableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NameTableViewController,
            segue.identifier == "profileTableViewSegue" {
            self.tableVC = vc
        }
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
        }
        
        // Styling of profile image
        profileImageToCircle()
        
        // Make sure the view are not in editing mode
        leaveEditing()
    }
    
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            // Display email from Auth-user
            
            displayUserAuths(currentUser: currentUser)
            
            userObj = dataModel.getUserStructure(user: user) as NSDictionary
            displayUserData()
        }
        else{
            print("error")
        }
    }
    
    func displayUserAuths(currentUser: User){
       self.tableVC?.mailLabel.text = currentUser.email!
    }
    
    // Load initial data and display name, profile picture, etc
    func displayUserData(){
        // Displaying name
        self.tableVC?.nameInputField.text =  userObj["username"] as? String
        
        let userID = userObj["id"] as! String
        let imageRef = dataModel.storageRef.child("image/\(userID).jpg") as StorageReference
        
        dataModel.displayImage(imageViewToUse: self.profileImage, userImageRef: imageRef)
    }


    // Entering editing mode
    @objc func enterEditing(sender: UIBarButtonItem) {
        // Setting buttons to done and cancle
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                                             action: #selector(cancelEditing(sender:))), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                              action: #selector(doneEditing(sender:))), animated: true)
        // Displays editing features
        changeProfileImageBtn.isHidden = false
        tableVC?.nameInputField.isUserInteractionEnabled = true
        tableVC?.nameInputField.clearButtonMode = UITextFieldViewMode.always
    }
    
    // Leaving editing mode
    func leaveEditing() {
        // Hides cancle button and sets editing button
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self,
                                                              action: #selector(enterEditing(sender:))), animated: true)
        self.navigationItem.leftBarButtonItem = nil
        
        // Hides editing features
        changeProfileImageBtn.isHidden = true
        tableVC?.nameInputField.isUserInteractionEnabled = false
        tableVC?.nameInputField.clearButtonMode = UITextFieldViewMode.never
    }
    
    // MARK: Actions
    // On cancle, leave editing mode and display previous data
    @objc func cancelEditing(sender: UIBarButtonItem) {
        leaveEditing()
        
        // Sets data to previous values
        displayUserData()
        
    }
    
    // On save, leave editing mode and save new data
    @objc func doneEditing(sender: UIBarButtonItem) {
        leaveEditing()
        
        // Saving changes to database
        dataModel.updateUserProfile(value: ["username" : tableVC?.nameInputField.text! ?? "no name"])
        
        //FIX ME: Add image to database too
        self.uploadImageToStorage(){url in
            if url != nil {
            }
        }
    }
    

    // Styling profile image
    func profileImageToCircle(){
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    // Change profile image
    func changeImage(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    // Image picker controller and cancle
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Update image in the view
        profileImage.image = chosenImage
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageToStorage(completion: @escaping (_ url: String?) -> Void) {
        let userID = userObj["id"] as! String
        let userImageRef = dataModel.storageRef.child("image/\(userID).jpg")
        
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
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

    // Logout and redirect to sign in
    func logOut(){
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
    
}

// Table view controller
class NameTableViewController: UITableViewController {
    // MARK: - Table view data source
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
