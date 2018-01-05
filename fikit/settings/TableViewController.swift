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
    
    var objectArray = [Objects]()
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
        
            //Reload lists
            self?.createUserList()
            
            self?.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    
    //TODO:
    // Clean up så vi gör som i FriendsModel - det var snyggare
    // fixa med ID med
    
    //Going trough lists of users and friends and sorting out friends
    //from users to be displayed in two different lists
    func createUserList(){
        for user in allUsers {
            var isFriend = false
            for friend in self.friends{
                if( user as! String == friend as! String){
                    isFriend = true
                    break
                }
            }
            //We append all non-friends to separate list
            if(!isFriend){
                nonFriends.append(user)
            }
        }
        //We append the friend list the the list of other users to the objects array that is displayed in table view
        self.objectArray.append(Objects(sectionName: "Vänner", sectionObjects: self.friends as! [String]))
        self.objectArray.append(Objects(sectionName: "Andra användare", sectionObjects: self.nonFriends as! [String]))
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

    //TODO: FIXA SÅ DEN BLIR SNYGGARE OCH LÄGGER IN ID OSV
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        //Clear so we can refresh view with correct data
        self.refreshLists()
        
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            self.friends = user["friends"] as! Array<Any>
            
            //loop through all users and append to users array
            for (key, _) in data as NSDictionary{
                let userloop = data[key] as! NSDictionary
                let username = userloop["username"] as! String //Check how we should append to get whole object
                allUsers.append(username)
            }
        }
        else{print("no user")}
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
