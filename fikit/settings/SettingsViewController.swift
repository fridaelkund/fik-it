//
//  SettingsViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-12-26.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var friendsContainer: UIView!
    
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex
        {
        case 0:
            profileContainer.isHidden = false
            friendsContainer.isHidden = true
        case 1:
            profileContainer.isHidden = true
            friendsContainer.isHidden = false
        default:
            break;
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileContainer.isHidden = false
        friendsContainer.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
