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

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Variables
    var dataModel = DataModel()
    var friends: Array<Any> = []
    
 //   var friends: Array<Any> = ["Frida", "Josefine", "Linnea"]
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "Fotocell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user data
        dataModel.observeDatabase { [weak self] (data: NSDictionary) in
            //When we have the data we can use it here
            self?.useData(data: data)
        }
    }
    
    //Using the data that we got from the model
    private func useData(data: NSDictionary) {
        if let currentUser = Auth.auth().currentUser{
            let user = data[currentUser.uid] as! NSDictionary
            self.friends = user["friends"] as! Array<Any>
        }
        else{print("no user")}
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InviteFriendSegue"{
            let destView = segue.destination as! inviteFriendViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {
           
            // I realize this isn't how you should do it, but it works.
                destView.name = friends[indexPath[0][1]] as! String
            }

        }
    }
}

// --- OK VAD GÖR DESSA HÄR ?? De kanske ska läggas i egna filer sen ?? ---


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
        
        //3
        cell.imageView.layer.cornerRadius = 70
        cell.imageView.clipsToBounds = true
        
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
