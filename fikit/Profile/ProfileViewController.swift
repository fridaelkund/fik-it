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
    
    //save changes
    @IBAction func saveChanges(_ sender: Any) {
        print(tableVC?.nameInputField.text!)
        updateUserName(newName: (tableVC?.nameInputField.text!)!)
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
    
    //TODO:
    //Add function for changing profile image
    
    
    // Update username
    func updateUserName(newName: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges { (error) in
            // ...
            print("committed new changes")
        }
    }
    
    // Styling of profile picture
    func profilePictureCircle(){
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        
        changeProfileImageBtn.isHidden = false
        
        // Toggles the actual editing actions appearing on a table view
        //tableView.setEditing(editing, animated: true)
    }
    
    

    
    // Function to load initial data and display name, profile picture, etc
    func loadInitialData(){
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
        loadInitialData()
        
        // Styling of profile image
        profilePictureCircle()
        
        // Adding edit button to navigation bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        changeProfileImageBtn.isHidden = true
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



