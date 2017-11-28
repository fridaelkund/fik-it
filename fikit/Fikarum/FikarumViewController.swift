//
//  FikarumViewController.swift
//  fikit
//
//  Created by Frida Eklund on 2017-11-28.
//

import UIKit
import Firebase

class FikarumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Variables
    var ref = Database.database().reference()
    var friends : Array<Any> = []
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "Fotocell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            //Observe status change in database for the user -- will be stored in self.status
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let users = value?["users"] as? NSDictionary
                let user = users?[currentUser.uid] as? NSDictionary
                let userFriends = user?["friends"] as? Any
                self.friends = userFriends as! [Any]
                print("Users friends are", self.friends)
            })
        }
        else{
            print("User is not authenticated - ERROR")
        }
        
        
        
        // Do any additional setup after loading the view.
    }

}

// MARK: - Private

// MARK: - UICollectionViewDataSource
extension FikarumViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FikarumPhotoCell
        //2
        cell.imageView.image = UIImage(named:"placeholderImage")
        
        return cell
    }
}


extension FikarumViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
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
