//
//  onboardingViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2018-01-09.
//

import UIKit

class onboardingViewController: UIViewController {

    @IBAction func doneButton(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
