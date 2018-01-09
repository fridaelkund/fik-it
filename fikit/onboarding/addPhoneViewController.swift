//
//  addPhoneViewController.swift
//  
//
//  Created by Frida Eklund on 2018-01-09.
//

import UIKit

class addPhoneViewController: UIViewController {
    var dataModel = DataModel()
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var missingPhoneNumber: UILabel!
    
    @IBAction func toImage(_ sender: Any) {
        if phoneNumber.text != nil{
            dataModel.updateUserProfile(value: ["phoneNumber" : phoneNumber.text! ])
            
            let viewController:UIViewController = UIStoryboard(name: "onboarding", bundle: nil).instantiateViewController(withIdentifier: "addImage") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }else{
            missingPhoneNumber.isHidden = false
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missingPhoneNumber.isHidden = true
    }

}
