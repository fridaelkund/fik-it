//
//  FikarumViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-28.
//

import UIKit
import Firebase
import FirebaseDatabase

class FikarumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
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
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InviteFriendSegue"{
            let destView = segue.destination as! inviteFriendViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {

                destView.name = self.onlineFriends[indexPath[0][1]]["username"] as! String
            }

        }
    }
    
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
        //2
        cell.imageView.image = UIImage(named:"placeholderImage")
        
        //3
        cell.imageView.layer.cornerRadius = 70
        cell.imageView.clipsToBounds = true
        
        // If we have a cell, hide empty state
        emptyStateLabel.isHidden = true
        
        return cell
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
