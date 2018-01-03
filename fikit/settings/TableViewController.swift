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

        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
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
            //self.allUsers = data
            //print(self.friends, self.allUsers)
            
            //DO THINGS WITH THE DATA
//            for (key, value) in users {
//               // print(key, value)
//                objectArray.append(Objects(sectionName: key, sectionObjects: value))
//            }
            
            //loop through all users and append to users array
            for (key, _) in data as NSDictionary{
                let userloop = data[key] as! NSDictionary
                let username = userloop["username"] as! String
                
                //APPEND IN RIGHT PLACE - so match is skipped but the rest is added one time each
                allUsers.append(username)
            }
            createUserList()
            
            //add all users to objectArray
           // objectArray.append(Objects(sectionName: "Alla användare", sectionObjects: allUsers as! [String]))
        }
        else{print("no user")}
    }
    
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
        objectArray.append(Objects(sectionName: "Vänner", sectionObjects: self.friends as! [String]))
        objectArray.append(Objects(sectionName: "Andra användare", sectionObjects: nonFriends as! [String]))
        
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
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
