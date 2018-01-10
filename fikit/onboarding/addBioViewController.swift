//
//  addBioViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2018-01-09.
//

import UIKit

class addBioViewController: UIViewController, UITextFieldDelegate {
    var dataModel = DataModel()
    
    @IBOutlet weak var missingBio: UILabel!
    @IBOutlet weak var addBio: UITextField!
    
    @IBAction func doneWithBio(_ sender: Any) {
        if(addBio.text != ""){
            dataModel.updateUserProfile(value: ["bio" : addBio.text! ])
            
            let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }else{
            missingBio.isHidden = false
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        missingBio.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
