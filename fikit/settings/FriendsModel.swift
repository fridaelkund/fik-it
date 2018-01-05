//
//  FriendsModel.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import Foundation
import Firebase

// *** Profile class ***
// Current user will become a Profile-object containing user-info
// along with list of friends and nonFriends to be used throughout
// the application

class Profile {
    var fullName: String?
    var status: String?
    var friends = [Friend]()
    var nonFriends = [Friend]()
   
    // *** TODO: Add ***
    //var pictureUrl: String?
    // var email: String?
    // var about: String?
    //  var status: String?
    // ******************
    
    init?(data: [String: AnyObject]?) {

        //This is the current user
        let currentUser = Auth.auth().currentUser
        let myFriendsIDList = data![currentUser!.uid]!["friends"]
        //Go through all users
        for user in data!{
            
            //For all users that is not the current user we want to check if user is friend or not
            if user.key != currentUser?.uid {
                
                //Make Friend object of user
                let tempUser = Friend(data: ["user": user.value])
                var isFriend = false
                
                //For all friends in the current users friendslist we check if the user is a friend
                for friendID in myFriendsIDList as! Array<Any>{
                    if( friendID as! String == user.key ){
                        isFriend = true
                        self.friends.append(tempUser)
                        break
                    }
                }
                
                //If user was not a friend we add to 'nonFriends'
                if(!isFriend){
                    self.nonFriends.append(tempUser)
                }
                
            }
            else{
                //It's the current user - let's add profile info
                self.fullName = user.value["username"] as? String
                self.status = user.value["status"] as? String
            }
        }
    }
}


// *** Friend class ***
// all users that are not the current user will
// become a Friend-object as they are or can be
// friends of the current user

class Friend {
    var name: String?
    var status: String?
    //var id: String?
    //var pictureUrl: String?
    
    init(data: [String : AnyObject]) {
        self.name = data["user"]!["username"] as? String
        self.status = data["user"]!["status"] as? String
        //self.id
        //self.pictureUrl = data["user"]!["picture"] as? String
    }
    
}

