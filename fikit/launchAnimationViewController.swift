//
//  launchAnimationViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2018-01-10.
//

import UIKit
import FirebaseAuth


class launchAnimationViewController: UIViewController {
    @IBOutlet weak var coffeeImageView: UIImageView!
    var viewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 0.24) { () -> Void in
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.24, delay: 0.12, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.24, delay: 0.36, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.24, delay: 0.48, options: .curveEaseIn, animations: { () -> Void in
            self.coffeeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: {(finished:Bool) in
            // the code you put here will be compiled once the animation finishes
            self.changeView()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeView() {
        let flag = UserDefaults.standard.bool(forKey: "fikit.firsttime.wasTheAppLoadedAlready")
        if !flag {
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as UIViewController
            
            UserDefaults.standard.set(true, forKey: "fikit.firsttime.wasTheAppLoadedAlready")
        } else {
            //   Depending if user is logged in, redirect to different screens
            if(Auth.auth().currentUser != nil){
                viewController = UIStoryboard(name: "fikaright", bundle: nil).instantiateViewController(withIdentifier: "Gofika") as UIViewController
            }else{
                viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn") as UIViewController
            }
        }
        self.present(viewController, animated: false, completion: nil)        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
