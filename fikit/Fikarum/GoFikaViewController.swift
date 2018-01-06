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
    
    var status = "offline" {
        didSet{
            //On change we call self.fikaMode() to update view
            self.fikaMode()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var toFikarumButton: UIButton!
    @IBOutlet weak var goFikaButton: UIButton!
    
    //MARK: Actions
    @IBAction func goFikaAction(_ sender: Any) {
        //Perform action depending on current status (toggle)
        if(status == "offline"){
            //Set online
            dataModel.setStatus(status: "online")
            
        }
        else if(status == "online"){
            //Set offline
            dataModel.setStatus(status: "offline")
      
        }
    }
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
        }
    }
    
    //Toggle fikamode buttons depending on status
    func fikaMode(){
        if(self.status == "offline"){
            goFikaButton.setTitle("Jag vill fika", for: .normal)
            toFikarumButton.isHidden = true
        }
        else{
            goFikaButton.setTitle("Jag vill inte fika", for: .normal)
            toFikarumButton.isHidden = false
        }
    }
    
    //MARK: Private functions
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
             self.status = user["status"] as? String ?? ""
        }
        else{print("no user")}
    }
    
    
}
