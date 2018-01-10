//
//  FikarumViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-28.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MessageUI

class FikarumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMessageComposeViewControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var youHaveFriendsLabel: UILabel!
    
    //MARK: Properties
    var dataModel = DataModel()
    var friends: Array<AnyObject> = []
    var onlineFriends: Array<AnyObject> = []

    fileprivate let reuseIdentifier = "Fotocell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyStateLabel.isHidden = true
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
            self?.collectionView.reloadData()
        }
        
    }
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "InviteFriendSegue"{
//            let destView = segue.destination as! inviteFriendViewController
//            if let indexPath = collectionView.indexPathsForSelectedItems {
//                destView.name = self.onlineFriends[indexPath[0][1]]["username"] as! String
//            }
//
//        }
//    }
    
    //MARK: Private functions
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            
            //Call function creating list of current users friends
            self.friends = dataModel.getFriendsList(hasFriends: user["hasFriends"] as! Bool, userFriends: user["friends"] as! Array<AnyObject>)
            
            self.onlineFriends = dataModel.getOnlineFriends(friends: self.friends, allUsers: data)
                        
            // Get only online friends
            if(self.onlineFriends.count < 1){
                emptyStateLabel.isHidden = false
                youHaveFriendsLabel.isHidden = true
            }
            
        }
        else{
            print("error")
        }
    }
}

// --- Creating collection view ---

// MARK: - UICollectionViewDataSource
extension FikarumViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onlineFriends.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FikarumPhotoCell
        
        //Creating image
        let userID = onlineFriends[indexPath[1]]["id"] as! String
        let imageRef = dataModel.storageRef.child("image/\(userID).jpg")
        dataModel.displayImage(imageViewToUse: cell.imageView, userImageRef: imageRef)
        
        //Setting nameLabel
        cell.nameLabel.text = onlineFriends[indexPath[1]]["username"] as? String
        
        //Setting image styling
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = cell.imageView.frame.height/2
        cell.imageView.clipsToBounds = true

        
         cell.onlineSymbol.layer.cornerRadius = cell.onlineSymbol.frame.height/2
        // If we have a cell, hide empty state
        emptyStateLabel.isHidden = true
        youHaveFriendsLabel.isHidden = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //SMS OR CALL THIS USER
        showActionSheet(friend: self.onlineFriends[indexPath[1]])
    }
    
    //Show action options
    func showActionSheet(friend: AnyObject){
        print(friend["phoneNumber"])
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let SMSAction = UIAlertAction(title: "SMS", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sendSMSText(phoneNumber: friend["phoneNumber"] as! String, username: friend["username"] as! String)
        })
        
        let callAction = UIAlertAction(title: "Call", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Call")
            //MAKE PHONE CALL
            self.callFriend(phoneNumber: friend["phoneNumber"] as! String)
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
            //CLOSING - no action
        })
        
        // 4
        optionMenu.addAction(SMSAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func sendSMSText(phoneNumber: String, username: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hej " + username + "! Jag såg att du var fikasugen på fik-it. Vill du fika med mig?"
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self as MFMessageComposeViewControllerDelegate
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func callFriend(phoneNumber: String){
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}


extension FikarumViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
