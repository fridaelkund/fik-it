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

    //MARK: Actions
    @IBAction func logoutAction(_ sender: Any) {
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

            //self?.reloadLists()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objectArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectArray[section].sectionObjects.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        //Button
        let button : UIButton = UIButton(type:UIButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x: 200,y :60), size: CGSize(width: 100, height: 24))
        let cellHeight: CGFloat = 44.0
        button.center = CGPoint(x: view.bounds.width / (4/3), y: cellHeight / 2.0)
        
        button.setTitleColor(.blue, for: .normal)
        button.tag = indexPath.row
        button.setTitle("Add", for: UIControlState.normal)
        button.addTarget(self, action: #selector(TableViewController.btnAction(_:)), for: .touchUpInside)
        
        
        if(objectArray[indexPath.section].sectionName == "Vänner"){
            print("VÄN")
            // Configure the cell...
            cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        }
        else{
            // Configure the cell...
            cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
            cell.addSubview(button)
        }
        
        return cell
    }
    
    
    @objc func btnAction(_ sender: UIButton) {
        print("LETS ADD", sender)
        let point = sender.convert(CGPoint.zero, to: self.tableView as UIView)
        print("POINT IS", point)
        let indexPath: IndexPath! = self.tableView.indexPathForRow(at: point)
        print("INDEX POINT IS", indexPath)
        // print(indexPath)
        // print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        
        sender.removeFromSuperview()
        //Perform addUserToFriends
        self.friends.append(objectArray[indexPath.section].sectionObjects[indexPath.row])
        
        //Add friends to Database
        dataModel.addFriends(friends: self.friends)
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    NSLog("You selected cell number: \(indexPath.row)!")
        
    }
    
    //MARK: Private functions
    
    //Clearing lists function
    private func refreshLists(){
        self.nonFriends = []
        self.objectArray = [Objects]()
        self.friends = []
        self.allUsers = []
    }

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
    
}
