//
//  Datamodel.swift
//  
//
//  Created by Josefine Möller on 2017-12-27.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class DataModel {
    
    //MARK: Properties
    var ref = Database.database().reference()
    var friends: Array<Any> = []
    var currentUser = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    //MARK: Functions
    //Observing and parsing user data
    func observeDatabase(completion: @escaping ((_ data: NSDictionary) -> Void)) {
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let users = value?["users"] as? NSDictionary
                
                //Completion - we have the user data
                completion(users!)
            })
    }
    
    //Observing and parsing user data
    func observeStorage(completion: @escaping ((_ data: NSDictionary) -> Void)) {
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let users = value?["users"] as? NSDictionary
            
            //Completion - we have the user data
            completion(users!)
        })
    }
    
//--- NOT USED ANYMORE BUT WILL FAIL IF WE REMOVE AS LONG AS WE KEEP OLD FILES ---
    func getData(onSuccess:  @escaping (Profile) -> Void) {
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject]
            let users = profileDict!["users"] as?  [String : AnyObject]
            self.friends = users![(self.currentUser?.uid)!]!["friends"] as! Array<Any>
            if let profile = Profile(data: users) {
                onSuccess(profile)
            }
            else{
                print("no profile")
            }
        })
    }
// -------------------------------------------------------------------------------
    
    //Add user info to database
    func addUser(){
        // Get id for new user
        self.currentUser = Auth.auth().currentUser
        
        self.ref.root.child("users").child((self.currentUser?.uid)!).setValue(
            ["username": self.currentUser?.displayName ?? "no name",
             "status": "offline",
             "hasFriends": false, //Used to check if user has friends or if we should display empty array
             "friends" : ["default friend"], //we need to have a fake-friend as default - else entry won't exist
            "id": self.currentUser?.uid as Any,
            "image": "images/\(self.currentUser?.uid as! String).jpg"]
        )
    }
    
    //Add new friends to database
    func addFriends(friends: Array<Any>) {
        var friendIDs: Array <Any> = []
        // Appending only IDs to database
        for friend in friends{
            let friend = friend as! NSDictionary
            let userObj = ["id": friend["id"] as! String]
            friendIDs.append(userObj)
        }
        
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(["friends": friendIDs])
        
        //Now user has friends
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(["hasFriends": true])
    }
    
    // Send profile data to database
    func updateUserProfile(value: Dictionary<String, Any>){
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(value)
    }
    
    //Setting status in database
    func setStatus(status: String){
        self.ref.child("users").child((self.currentUser?.uid)!).child("/status").setValue(status)
    }
    
    //SignUp
    func signUp(email: String, password: String, completion: @escaping ((_ data: String) -> Void)){
        //Lets authenticate and create user in firebase
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("You have successfully signed up")
                completion("Success")
            }
            else {
                print(error?.localizedDescription ?? "Signup failed")
               completion("Fail")
            }
        }
    }
    
    //RETURNING DATA STRUCTURES
    
    //Returning friendsLists depending on if user has friends or not 
    func getFriendsList(hasFriends: Bool, userFriends: Array<AnyObject>) -> Array<AnyObject>{
        var friends: Array<AnyObject> = []
        //If user has friends we fetch them, else we start with empty friends array
        if(hasFriends){
            friends = userFriends
        }
        return friends
    }
    
    //Creating a Dictionary with user info and returning it
    
    func getUserStructure(user: NSDictionary) -> Dictionary <AnyHashable, Any> {
        var userObj: Dictionary = [:] as Dictionary
        let username = user["username"] as! String
        let userid = user["id"] as! String
        let userImage = user["image"] as! String
        
        userObj = ["id": userid,
                   "username": username,
                   "image": userImage]
        
        return userObj
    }
    
    func getOnlineFriends(friends: Array<AnyObject>, allUsers: NSDictionary) -> Array<AnyObject>{
        var onlineFriends: Array<AnyObject> = []
        
        for friend in friends{
            let friendStatus = (allUsers[friend["id"]] as! NSDictionary)["status"] as! String
            if friendStatus == "online"{
                onlineFriends.append(allUsers[friend["id"]] as! NSDictionary)
            }
        }
        return onlineFriends
    }
    
    
    func displayImage(imageViewToUse: UIImageView, userImageRef: StorageReference){
        userImageRef.downloadURL { url, error in
            if error != nil {
                print("Error")
            } else {
                imageViewToUse.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
            }
        }
    }


}
