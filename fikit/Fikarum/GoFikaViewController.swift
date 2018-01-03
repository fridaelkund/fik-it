//
//  GoFikaViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-13.
//

import UIKit
import Firebase
import FirebaseDatabase

class GoFikaViewController: UIViewController {
    //MARK: Properties
    var dataModel = DataModel()
    var ref = Database.database().reference()
    var status = "offline"
    
    //MARK: Outlets
    @IBOutlet weak var toFikarumButton: UIButton!
    @IBOutlet weak var goFikaButton: UIButton!
    
    //MARK: Actions
    @IBAction func goFikaAction(_ sender: Any) {
            //Perform action depending on current status (toggle)
            if(status == "offline"){
                //Set online
                dataModel.setStatus(status: "online")
                
                //View update
                goFikaButton.setTitle("Go offline", for: .normal)
                toFikarumButton.isHidden = false
            }
            else if(status == "online"){
                //Set offline
                dataModel.setStatus(status: "offline")
                
                //View update
                goFikaButton.setTitle("Go online", for: .normal)
                toFikarumButton.isHidden = true
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            //Hide Fika-room button in the beginning. User needs to be "online" to access it
            toFikarumButton.isHidden = true
            
            //Get user data
            dataModel.observeDatabase { [weak self] (data: NSDictionary) in
                //When we have the data we can use it here
                self?.useData(data: data)
            }
        
        
    }
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
             self.status = user["status"] as? String ?? ""
        }
        else{print("no user")}
    }
    
    
}
