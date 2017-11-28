//
//  GoFikaViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-13.
//

import UIKit
import Firebase
import FirebaseDatabase

class GoFikaViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var toFikarumButton: UIButton!
    @IBOutlet weak var goFikaButton: UIButton!
    
    //MARK: Variables
    //Reference to Database
    var ref = Database.database().reference()
    var status = "offline"
    
    //MARK: Actions
    @IBAction func goFikaAction(_ sender: Any) {
        
        //User needs to be logged in and we need to access the
        //currentUser.uid to be able to locate user info in database
        if let currentUser = Auth.auth().currentUser {
            //Perform action depending on current status (toggle)
            if(status == "offline"){
                //Set online in database
                self.ref.child("users").child(currentUser.uid).child("/status").setValue("online")
                //View update
                goFikaButton.setTitle("Go offline", for: .normal)
                toFikarumButton.isHidden = false
            }else if(status == "online"){
                //Set offline in database
                self.ref.child("users").child(currentUser.uid).child("/status").setValue("offline")
                //View update
                goFikaButton.setTitle("Go online", for: .normal)
                toFikarumButton.isHidden = true
            }
        }
        else{
            //User is not logged in so nothing should be possible
            print("NO USER IS LOGGED IN - ERROR! ")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //User needs to be authenticated/signed in in order to use the app and we need user data
        if let currentUser = Auth.auth().currentUser {
            
            //Add user to database
            self.ref.child("users").child(currentUser.uid).setValue(
                ["username": currentUser.displayName,
                 "status": "offline",
                 "friends": ["frida", "josefine", "alex", "linnea"]])

            //Hide Fika-room button in the beginning. User needs to be "online" to access it
            toFikarumButton.isHidden = true
            
            
            //Observe status change in database for the user -- will be stored in self.status
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let users = value?["users"] as? NSDictionary
                print("All users", users)
                let user = users?[currentUser.uid] as? NSDictionary
                let userStatus = user?["status"] as? String ?? ""
                self.status = userStatus
                print("Fika status is ", self.status)
            })
            
        }
        else{
            //User not logged in - we should not be here
            print("No user logged in")
        }
        
        
    }
    

    
    
}
