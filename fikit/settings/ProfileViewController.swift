//
//  ProfileViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-12-29.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: Properties
    var dataModel = DataModel()
    
    //MARK: Actions
    
    //Logout action
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            //Set status to offline in database for the user when signed out
            dataModel.setStatus(status: "offline")
            
            //Switch view to "SignUp" view
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
            present(vc, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Logout error", error.localizedDescription)
        }

    }
    
    
    //MARK: Functions
    
    //Updating userInfo on authentication object
    //THIS FUNCTIONS CHANGES NAME TO PRESET VALUE - we can have this value as anything
    func updateUserInfo(){
        
        //TODO:
        //Make this function work with edit option in storyboard and
        //have it change name to any new name typed in
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Josefine Testuser"
        changeRequest?.commitChanges { (error) in
            // ...
            print("committed new changes")
            self.nameLabel.text = changeRequest?.displayName
        }
    }
    
    //TODO:
    //Add function for changing profile image
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
            
            //Display username
            nameLabel.text = currentUser.displayName
            
            //Display profile image
            if currentUser.photoURL != nil {
                let url = NSURL(string:(currentUser.photoURL?.absoluteString)!)
                let data = NSData(contentsOf:url! as URL)
                
                // If data is not null
                if data!.length > 0 {
                    profileImage.image = UIImage(data:data! as Data)
                }
//                else {
//                    //SET PLACEHOLDER IMAGE
//                    print("placeholder here")
//                    //It's already set I think
//                }
            }
//            else {
//                print("No image avaliable")
//                // SET PLACEHOLDER ???
//                //It's already set
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
