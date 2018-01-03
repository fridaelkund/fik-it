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
    var users = ["Vänner": ["Tomato", "Potato", "Lettuce"], "Andra användare": ["Apple", "Banana"]]
    
    var dataModel = DataModel()
    var friends: Array<Any> = []
    var allUsers: Array<Any> = []
    var nonFriends: Array<Any> = []

    
    @IBAction func logoutAction(_ sender: Any) {
        print("log me out")
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Logout error", error.localizedDescription)
        }
        
        //Set status to offline in database for the user when signed out
        dataModel.setStatus(status: "offline")
        
        //Switch view to "login" view
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
        present(vc, animated: true, completion: nil)
        
    }

    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Epmty lists
        self.friends = []
        self.allUsers = []
        self.nonFriends = []

        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
            //Reload data so it appears in view
            self?.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            self.friends = user["friends"] as! Array<Any>
            
            //loop through all users and append to users array
            for (key, _) in data as NSDictionary{
                let userloop = data[key] as! NSDictionary
                let username = userloop["username"] as! String
                allUsers.append(username)
            }
            createUserList()
        }
        else{print("no user")}
    }
    
    //Going trough lists of users and friends and sorting out friends
    //from users to be displayed in two different lists
    func createUserList(){
        for user in allUsers {
            var isFriend = false
            print("in allUsers loop")
            for friend in self.friends{
                print("in friends loop")
                if( user as! String == friend as! String){
                    print("the user is", user, "the friend is", friend)
                    print("IT'S A FRIEND")
                    isFriend = true
                    break
                }
            }
            if(!isFriend){
                print("the user is not a friend")
                nonFriends.append(user)
                
            }
            else{
                print("FRIEND")
            }
           
        }
        //We append the friend list the the list of other users to the objects array that is displayed in table view
        objectArray.append(Objects(sectionName: "Vänner", sectionObjects: self.friends as! [String]))
        objectArray.append(Objects(sectionName: "Andra användare", sectionObjects: self.nonFriends as! [String]))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objectArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectArray[section].sectionObjects.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
       cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return objectArray[section].sectionName
    }

}
