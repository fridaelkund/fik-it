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
    
    //Add user info to database
    func addUser(){
        // We can only add the user if there is one
        if let currentUser = Auth.auth().currentUser {
            self.ref.root.child("users").child(currentUser.uid).setValue(
                ["username": currentUser.displayName ?? "no name",
                 "status": "offline",
                 "phoneNumber" : "707496422",
                 "bio" : "biotext",
                 "hasFriends": false, //Used to check if user has friends or if we should display empty array
                 "friends" : ["default friend"], //we need to have a fake-friend as default - else entry won't exist
                "id": currentUser.uid as Any,
                "image": "images/\(currentUser.uid).jpg"]
            )
        }
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
        self.ref.child("users").child((self.currentUser?.uid)!).updateChildValues(["status" : status])
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
        let phoneNumber = user["phoneNumber"] as! String
        let bio = user["bio"] as! String
        let status = user["status"] as! String
        
        userObj = ["id" : userid,
                   "username" : username,
                   "image" : userImage,
                   "phoneNumber" : phoneNumber,
                   "bio" : bio,
                   "status" : status]
        
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
    
    //Check phone number with regular expression to see if it's valid or not
    func checkPhoneNumber(value: String) -> Bool {
        let correctNumber = "^[0-9]{9}$"
        let checkNumber = NSPredicate(format: "SELF MATCHES %@", correctNumber)
        let isValid = checkNumber.evaluate(with: value)
        return isValid
    }


}
