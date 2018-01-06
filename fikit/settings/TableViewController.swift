//
//  TableViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TableViewController: UITableViewController {

    //MARK: Properties
    var dataModel = DataModel()
    var friends: Array<Any> = []
    var allUsers: Array<Any> = []
    var nonFriends: Array<Any> = []

    //MARK: Object
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    //Array for storing objects
    var objectArray = [Objects]()
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
            self?.tableView.reloadData()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    // We want as many sections as we have objects in objectsArray
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    // We want as many rows in each section as the number of items for each object in ObjectsArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }

  
    // creating cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        return cell
    }
    
    // setting the title according to sectionName in objectsArray
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }

    
    // Selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    NSLog("You selected cell number: \(indexPath.section)!")
        //If non-friends section
        if(indexPath.section == 1){
            print("we should add this friend")
         
            alertWindow(title: "Add friend", message: "Do you want do add " + objectArray[indexPath.section].sectionObjects[indexPath.row] + " as your friend?", indexPath: indexPath)
            
        }
        //If friends section
        else{
            print("we should not add")
            //MAYBE ADD REMOVE FRIEND HERE
        }
    }
    
    
    //MARK: Private functions
    
    //Clearing lists function
    private func refreshLists(){
        self.nonFriends.removeAll()
        self.objectArray.removeAll()
        self.friends.removeAll()
        self.allUsers.removeAll()
    }

    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        //Clear so we can refresh view with correct data
        self.refreshLists()
        
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            
            //Call function creating list of current users friends
            self.friends = dataModel.getFriendsList(hasFriends: user["hasFriends"] as! Bool, userFriends: user["friends"] as! Array<Any>)
            
            //loop through all users
            for (key, _) in data as NSDictionary{
                let userloop = data[key] as! NSDictionary
                
                if key as? String != currentUser.uid {
                    var isFriend = false
                    //We check for nonFriends among all users
                    for friend in self.friends {
                        if(friend as! String == key as! String){
                            isFriend = true
                            break
                        }
                    }
                    
                    //If user was not a friend we add to 'nonFriends'
                    if(!isFriend){
                        let username = userloop["username"] as! String //Check what to add here
                        self.nonFriends.append(username)
                    }
                    
                }
            }
            //We append the friend list the the list of other users to the objects array that is displayed in table view
            self.objectArray.append(Objects(sectionName: "Vänner", sectionObjects: self.friends as! [String]))
            self.objectArray.append(Objects(sectionName: "Andra användare", sectionObjects: self.nonFriends as! [String]))
        }
    }
    
   // Modal for confirming adding a user
    private func alertWindow(title: String, message: String, indexPath: IndexPath){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            self.friends.append(self.objectArray[indexPath.section].sectionObjects[indexPath.row])
            self.dataModel.addFriends(friends: self.friends)
        }
        alertController.addAction(OKAction)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        //Show modal
        self.present(alertController, animated: true, completion:nil)
    }
    
    
}
