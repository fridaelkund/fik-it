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

    //MARK: Functions
    
    //Observing and parsing user data
    func observeDatabase(completion: @escaping ((_ data: NSDictionary) -> Void)) {

//        if let currentUser = Auth.auth().currentUser{
            //Observe user information from database
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let users = value?["users"] as? NSDictionary
                
                //let user = users?[currentUser.uid] as? NSDictionary
                
                //self.user = user!
                
                //Completion - we have the user data
                completion(users!)
            })
//        }
//        else{
//            //Add redirect here later (to login page)
//            print("no current user")
//        }
    }
    
    //Setting status in database
    func setStatus(status: String){
        
        if let currentUser = Auth.auth().currentUser {
            if(status == "offline"){
                self.ref.child("users").child(currentUser.uid).child("/status").setValue("offline")
            }
            else{
                self.ref.child("users").child(currentUser.uid).child("/status").setValue("online")
            }
        }
        else{
            //Add redirect here later (to login page)
            print("no current user")
        }
    }
    
    //TODO: FIXA SÅ DEN INTE LÄGGER TILL SÅHÄR
    
    //Add user info to database
    func addUser(){
        //FRIEND LIST SHOULD NOT BE LIKE THIS (need to be different for all users, containing ids or something)
        if let currentUser = Auth.auth().currentUser {
            self.ref.child("users").child(currentUser.uid).setValue(
                ["username": currentUser.displayName ?? "no name",
                 "status": "offline",
                 "friends": ["frida", "Josefine Möller", "alex", "linnea"]]
            )
        }
        else{
            //Add redirect here later (to login page)
            print("no current user")
        }
    }
    
    func addFriends(friends: Array<Any>) {
        print("friends are", friends as! [String])
         if let currentUser = Auth.auth().currentUser {
            //self.ref.child("users").child(currentUser.uid).updateChildValues(["friends" : friends])
            self.ref.root.child("users").child(currentUser.uid).updateChildValues(["friends": friends])

        }
    }
    
    // Send data to database
    func updateDatabase(value: Dictionary<String, Any>){
        print("adding to database")
        if let currentUser = Auth.auth().currentUser {
            self.ref.root.child("users").child(currentUser.uid).updateChildValues(value)
        }
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
    
    //Logout
    func logout(){
        
    }

}
