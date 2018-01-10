//
//  addNameViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2018-01-09.
//

import UIKit

class addNameViewController: UIViewController {
    var dataModel = DataModel()
    
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var missingName: UILabel!
    
    @IBAction func toEmail(_ sender: Any) {
        if addName.text != ""{
            dataModel.updateUserProfile(value: ["username" : addName.text! ])
        
            let viewController:UIViewController = UIStoryboard(name: "onboarding", bundle: nil).instantiateViewController(withIdentifier: "addPhone") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
        else{
            missingName.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         missingName.isHidden = true
    }
    
}
