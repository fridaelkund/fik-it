//
//  ProfileViewModel.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import Foundation
import UIKit

// --------------- HERE WE CONTROLL THE FRIENDSVIEW ---------------


// **************** DEFINING ITEM TYPES ****************

//Item types
enum FriendsViewModelItemType {
    case friend
    case nonFriend
}

// Item structure
protocol FriendsViewModelItem {
    var type: FriendsViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

protocol FriendsViewModelDelegate: class {
    func didFinishUpdates()
}

// *******************************************************



// **************** CREATING ITEMS ****************


// *** NonFriend-item ***
class FriendsViewModelNonFriendsItem: FriendsViewModelItem{
    //Setting the type as nonFriend (used to decide what cell to create for the item)
    var type: FriendsViewModelItemType {
        return .nonFriend
    }
    
    var sectionTitle: String {
        return "Other users"
    }
    
    var rowCount: Int {
        return nonFriends.count
    }
    
    var nonFriends: [Friend]
    
    init(nonFriends: [Friend]) {
        self.nonFriends = nonFriends
    }
}

//*** Friend-item ***
class FriendsViewModelFriendsItem: FriendsViewModelItem {
    //Setting the type as nonFriend (used to decide what cell to create for the item)
    var type: FriendsViewModelItemType {
        return .friend
    }
    
    var sectionTitle: String {
        return "Friends"
    }
    
    var rowCount: Int {
        return friends.count
    }
    
    var friends: [Friend]
    
    init(friends: [Friend]) {
        self.friends = friends
    }
}

// ****************************************************************


// **************** STORING ITEMS *********************

// Creating list of items - item can be friends or nonFriend (see FriendsViewModelItemType)
class FriendsViewModel: NSObject {
    // Here we store the FriendsItems
    var items = [FriendsViewModelItem]() // this array can be modified to fit our needs. Also reachable from any Controller
    // dataModel - connection
    var dataModel = DataModel()
    
    weak var delegate: FriendsViewModelDelegate?

    override init() {
        super.init()
    }
    
    // Parsing data from Profile-object and storing it in items[]
    private func parseData(profile: Profile) {
        //Start with clearing items so we don't have anything old left
        items.removeAll()
        
        //Based on Profile we populate items
        let friends = profile.friends //list of friends from Profile
       
        // we only need friends item if friends not empty
        if !profile.friends.isEmpty {
            //Create a FriendsViewModelFriendsItem of the friendsList
            let friendsItem = FriendsViewModelFriendsItem(friends: friends)
            //append the created item - it will be of correct type for case switching
            items.append(friendsItem)
        }
     
        let nonFriends = profile.nonFriends
        // we only need friends item if friends not empty
        if !profile.friends.isEmpty {
            let nonFriendsItem = FriendsViewModelNonFriendsItem(nonFriends: nonFriends)
            items.append(nonFriendsItem)
        }
        
        delegate?.didFinishUpdates()
    }
        
    //Listening for loadData function in 'DataModel'-file that is fetching from Database
    func loadData() {
        dataModel.getData { [weak self] profile in
            //When we have a profile (called from loadData we can parse it
            self?.parseData(profile: profile)
        }
    }
    
}
// ******************************************************


//**************** TABLEVIEW - USE ITEMS ****************************
extension FriendsViewModel: UITableViewDataSource {
    
    // Number of sections in the FriendsView - depending on how many items are in our items array
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    // Number of rows in each section - depending on the rowCount for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
   
    // Handling cells depending on item/case
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // we get the right item from the items array
        let item = items[indexPath.section]
        
        //Depending on the item.type we create specific cells
        switch item.type {
            case .friend:
                if let item = item as? FriendsViewModelFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell {
                        // store the friend as cell.item (we can reach this as self.item in FriendsCell.swift)
                        let friend = item.friends[indexPath.row]
                        cell.item = friend
                        return cell
                }
            case .nonFriend:
                if let item = item as? FriendsViewModelNonFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: NonFriendCell.identifier, for: indexPath) as? NonFriendCell {
                        // store the friend as cell.item (we can reach this as self.item in NonFriendCell.swift)
                        let nonFriend = item.nonFriends[indexPath.row]
                        cell.item = nonFriend
                        return cell
                }
        }
        
        // return the default cell if none of above succeed
        return UITableViewCell()
    }
    
    
    //You can use the same structure to setup the didSelectRowAt delegate method:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.section].type {
        case .friend:
            print("it's a friend")
      
        case .nonFriend:
            print("not friend")
        }
    }
    
    
    // Displaying the correct section-header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath){
        
        
        print("TAPPED")
    }

    
}

// **************** END OF TABLE VIEW ************************

