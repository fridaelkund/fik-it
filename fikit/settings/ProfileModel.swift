//
//  ProfileModel.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import Foundation
import Firebase

//User
class Profile {
    var fullName: String?
    var status: String?
    //var pictureUrl: String?
   // var email: String?
   // var about: String?
    var friends = [Friend]()
    var nonFriends = [Friend]()
    //  var status: String?
    
    init?(data: [String: AnyObject]?) {
    
        //WE HAVE ALL DATABASE DATA HERE
        let currentUser = Auth.auth().currentUser
        let myFriendsIDList = data![currentUser!.uid]!["friends"]
        
        for user in data!{
            //Skapa user
           
            if user.key != currentUser?.uid {
                
                var tempUser = Friend(data: ["user": user.value])
                
                var isFriend = false
                
                for friendID in myFriendsIDList as! Array<Any>{
                    print(friendID, user.key)
                    if( friendID as! String == user.key ){
                        isFriend = true
                        self.friends.append(tempUser)
                        break
                    }
                }
                if(!isFriend){
                    self.nonFriends.append(tempUser)
                }
                
            }
            else{
                //print("current")
            }
            print("NON FRIENDS", self.nonFriends)
            print("NON FRIENDS", self.friends)
        }
        
      
        
//        if let currentUser = Auth.auth().currentUser {
//            self.fullName = data![currentUser.uid]!["username"] as? String
//            self.status = data![currentUser.uid]!["status"] as? String
//
//            if let friends = data![currentUser.uid]!["friends"] as? [[String: Any]] {
//                self.friends = friends.map { Friend(json: $0) }
//            }
//
//        }
      

//        self.fullName = body["username"] as? String
//        self.pictureUrl = "no url" //body["pictureUrl"] as? String
//        self.about = "no about" //body["about"] as? String
//        self.email = "no email now" //body["email"] as? String
//
//        if let friends = body["friends"] as? [[String: Any]] {
//            self.friends = friends.map { Friend(json: $0) }
//        }
        
    }
    
}
//Friend
class Friend {
    var name: String?
    var id: String?
    var status: String?
    var pictureUrl: String?
    
    init(data: [String : AnyObject]) {
       
        self.name = data["user"]!["username"] as! String
        self.status = data["user"]!["status"] as! String
        
      //  self.name = json["name"] as? String
      //  self.pictureUrl = json["pictureUrl"] as? String
        //self.status ...
        //self.id ...
    }
}
//class Attribute {
//    var key: String?
//    var value: String?
//}

