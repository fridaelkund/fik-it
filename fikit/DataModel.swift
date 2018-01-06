//
//  Datamodel.swift
//  
//
//  Created by Josefine Möller on 2017-12-27.
//

import UIKit
import Firebase

class DataModel {
    
    //MARK: Properties
    var ref = Database.database().reference()
    var friends: Array<Any> = []
    var currentUser = Auth.auth().currentUser
    
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
    
//--- NOT USED ANYMORE BUT WILL FAIL IF WE REMOVE AS LONG AS WE KEEP OLD FILES ---
    func getData(onSuccess:  @escaping (Profile) -> Void) {
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject]
            let users = profileDict!["users"] as?  [String : AnyObject]
            self.friends = users![(self.currentUser?.uid)!]!["friends"] as! Array<Any>
            print("FRIENDS ARE", self.friends)
            if let profile = Profile(data: users) {
                onSuccess(profile)
            }
            else{
                print("no profile")
            }
        })
    }
// -------------------------------------------------------------------------------
    
    
    //Setting status in database
    func setStatus(status: String){
        self.ref.child("users").child((self.currentUser?.uid)!).child("/status").setValue(status)
    }
    
    
    //Add user info to database
    func addUser(){
        self.ref.child("users").child((self.currentUser?.uid)!).setValue(
            ["username": self.currentUser?.displayName ?? "no name",
             "status": "offline",
             "hasFriends": false, //Used to check if user has friends or if we should display empty array
             "friends" : ["default friend"], //we need to have a fake-friend as default - else entry won't exist
                "id": self.currentUser?.uid as Any]
        )
    }
    
    //Add new friends to database
    func addFriends(friends: Array<Any>) {
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(["friends": friends])
        //Now user has friends
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(["hasFriends": true])
    }
    
    //ARE WE USING ?? check so that it works with addFriends-changes in that case
    // Send data to database
    func updateDatabase(value: Dictionary<String, Any>){
        self.ref.root.child("users").child((self.currentUser?.uid)!).updateChildValues(value)
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
    

    func getFriendsList(hasFriends: Bool, userFriends: Array<Any>) -> Array<Any>{
        var friends: Array<Any> = []
        //If user has friends we fetch them, else we start with empty friends array
        if(hasFriends){
            friends = userFriends
        }
        return friends
    }
    
}
