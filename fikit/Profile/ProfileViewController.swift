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
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfileImageBtn: UIButton!
    
    //MARK: Actions
    
    //change image
    @IBAction func changeImageAction(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
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
    //Image picker
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
    
    // Styling of profile picture
    func profilePictureCircle(){
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    //TODO:
    //Add function for changing profile image
    

    // Functions for editing data
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
    
    @objc func cancelEditing(sender: UIBarButtonItem) {
        leaveEditing()
        
        // Sets data to previous values
        displayUserData()
        
    }
    
    @objc func doneEditing(sender: UIBarButtonItem) {
        leaveEditing()
        
        // Saving changes, locally and to database
        updateUserName(newName: (tableVC?.nameInputField.text!)!)
        print("In done editing")
        dataModel.updateDatabase(value: ["username" : tableVC?.nameInputField.text!])
        
        // Skicka in bild sen också?
    }
    
    // Update username
    func updateUserName(newName: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges { (error) in
            // ...
            print("committed new changes")
        }
    }
    
    // Function to load initial data and display name, profile picture, etc
    func displayUserData(){
        if let currentUser = Auth.auth().currentUser {
            
            // Display name and email
            self.tableVC?.nameInputField.text = currentUser.displayName
            self.tableVC?.mailLabel.text = currentUser.email
            
            //Display profile image
            if currentUser.photoURL != nil {
                let url = NSURL(string:(currentUser.photoURL?.absoluteString)!)
                let data = NSData(contentsOf:url! as URL)
                
                // If data is not null
                if data!.length > 0 {
                    profileImage.image = UIImage(data:data! as Data)
                }
            }else{
                profileImage.image = UIImage(named: "placeholderImage")
            }
        }
    }
    
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
        
        // Loading of intial data
        displayUserData()
        
        // Styling of profile image
        profilePictureCircle()
        
        // Make sure the view are not in editing mode
        leaveEditing()
    }
}


// MARK: Table view controller
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
