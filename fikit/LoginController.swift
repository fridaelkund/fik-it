//
//  LoginController.swift
//  fikit
//
//  Created by Josefine Möller on 2017-11-07.

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Firebase

class LoginController: UIViewController {
    //MARK: Variables
    var dict : [String : AnyObject]!
    var friendsdict : [String : AnyObject]!
    
    //MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var permissionsLabel: UILabel!
    
    //MARK: Actions
    
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                self.getFBUserData()
            }
        }
    }
    
    //When view load
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = LoginButtonDelegate.self as? LoginButtonDelegate
        loginButton.center = view.center;
        
        view.addSubview(loginButton)
        
        self.getFBUserData()
    }
    
    
    func handleImageURLs(){
        //Handle profile picture url
        if let imageURL = ((self.dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
            //Download image from imageURL
            let url = NSURL(string:imageURL)
            let data = NSData(contentsOf:url! as URL)
    
            // It is the best way to manage nil issue.
            if data!.length > 0 {
                self.profileImage.image = UIImage(data:data! as Data)
            } else {
                // In this when data is nil or empty then we can assign a placeholder image
                //SET PLACEHOLDER IMAGE HERE
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        //If accesstoken
        if((FBSDKAccessToken.current()) != nil){
            
            //Request parameters for user
            //We want if, name, picture and email
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                //If no error we have a valid response
                if (error == nil){
                    //Save result in dict
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    //Write user name to label
                    self.permissionsLabel.text = self.dict["name"] as? String
                    //Handle image urls
                    self.handleImageURLs()
                }
            })
            
            //Get friends list - will only return 'friends who have signed up in the app' - we can add 'invite through facebook' if we want too. But this is what there seems to be support for atm.
            FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": ""]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //Save result in friends-dict
                    self.friendsdict = result as! [String : AnyObject]
                    print(result!)
                    print(self.friendsdict)
                    
                    //Display friends
                    self.showFriends()
                }
            })
        }
    
    }
    
    //function printing friends
    func showFriends(){
        print("test", self.friendsdict["data"] ?? "No data")
    }
    
    func firebaseLogin(){
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        // Perform login by calling Firebase APIs
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            // Present the main view
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    

} // End of LoginController
