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
    
    @IBAction func toEmail(_ sender: Any) {
        dataModel.updateUserProfile(value: ["username" : addName.text! ?? "no name"])
        
        let viewController:UIViewController = UIStoryboard(name: "onboarding", bundle: nil).instantiateViewController(withIdentifier: "addEmail") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
