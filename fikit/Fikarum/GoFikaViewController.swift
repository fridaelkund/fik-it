//
//  GoFikaViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-13.
//

import UIKit

class GoFikaViewController: UIViewController {

    @IBOutlet weak var toFikarumButton: UIButton!
    @IBOutlet weak var goFikaButton: UIButton!
    
    var status = "offline"
    
    @IBAction func goFikaAction(_ sender: Any) {
        if(status == "offline"){
            status = "online"
            print("online")
            goFikaButton.setTitle("Go offline", for: .normal)
            toFikarumButton.isHidden = false
        }else if(status == "online"){
            status = "offline"
            print("offline")
            goFikaButton.setTitle("Go online", for: .normal)
            toFikarumButton.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(status == "offline"){
            toFikarumButton.isHidden = true
        }
    }
    
}
