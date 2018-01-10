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
    
    var status: String = ""
    
    //MARK: Outlets
    @IBOutlet weak var toFikarumButton: UIButton!
    @IBOutlet weak var goFikaButton: UIButton!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userStatusSymbol: UIView!
    
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
        print("Först i view did", self.status)
        goFikaButton.isHidden = true
        toFikarumButton.isHidden = true
        userStatus.isHidden = true
        userStatusSymbol.isHidden = true
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
            self?.fikaMode()
        }
        userStatusSymbol.layer.cornerRadius = userStatusSymbol.frame.height/2
    }
    
    func display() {
        print("I view will appear", self.status)
        goFikaButton.isHidden = false
        userStatus.isHidden = false
        userStatusSymbol.isHidden = false
    }
    
    //Toggle fikamode buttons depending on status
    func fikaMode(){
        print("I fikaMode", self.status)
        if(self.status == "offline"){
            goFikaButton.setTitle("Jag vill fika", for: .normal)
            toFikarumButton.isHidden = true
            userStatus.text = "Du är inte tillgänglig i fikarummet"
            userStatusSymbol.backgroundColor = UIColor.gray
        }
        else{
            goFikaButton.setTitle("Jag vill inte fika", for: .normal)
            toFikarumButton.isHidden = false
            userStatus.text = "Du är nu tillgänglig i fikarummet"
            userStatusSymbol.backgroundColor = self.hexStringToUIColor(hex: "#5DA177")
        }
        self.display()
    }
    
    //MARK: Private functions
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            print("Sätter status", self.status)
            self.status = user["status"] as? String ?? ""
        }
        else{
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
