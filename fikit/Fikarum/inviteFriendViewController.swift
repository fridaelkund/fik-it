//
//  inviteFriendViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-13.
//

import UIKit

class inviteFriendViewController: UIViewController {
    
    var name: String = ""
    @IBOutlet weak var inviteFriendLabel: UILabel!
    
    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteFriendLabel?.text = name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
