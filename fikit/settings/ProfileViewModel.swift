//
//  ProfileViewModel.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import Foundation
import UIKit

//Each case different cell
enum ProfileViewModelItemType {
    case friend
    case nonFriend
}


//Provides computed properties to items
protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}


protocol ProfileViewModelDelegate: class {
    func didFinishUpdates()
}

//Can be used from any ViewController - Will provide the array of sections for TableView
// --> Now if you want to reorder, add or remove the items, you just need to modify this ViewModel items array. Pretty clear, right?

class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    var dataModel = DataModel()

    weak var delegate: ProfileViewModelDelegate?

    
    override init() {
        super.init()
    }
    
    
    private func parseData(profile: Profile) {
        print("profile in parse", profile)
        items.removeAll()
        //Based on Model we provide items
        let friends = profile.friends
        print("friends is", friends)
        // we only need friends item if friends not empty
        if !profile.friends.isEmpty {
            let friendsItem = ProfileViewModelFriendsItem(friends: friends)
            items.append(friendsItem)
        }
        //OBS FIXA ANNAN LISTA HÄR
        let nonFriends = profile.nonFriends
        // we only need friends item if friends not empty
        if !profile.friends.isEmpty {
            let friendsItem = ProfileViewModelNonFriendsItem(nonFriends: nonFriends)
            items.append(friendsItem)
        }
        delegate?.didFinishUpdates()
    }
    
    func loadData() {
        dataModel.getData { [weak self] profile in
            self?.parseData(profile: profile)
        }
    }
    
}


//TABLEVIEW
extension ProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
   
    //Handling cells depending on item/case
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .friend:
            if let item = item as? ProfileViewModelFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .nonFriend:
            if let item = item as? ProfileViewModelNonFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: NonFriendCell.identifier, for: indexPath) as? NonFriendCell {
                let nonFriend = item.nonFriends[indexPath.row]
                cell.item = nonFriend
                return cell
            }
        }
        // return the default cell if none of above succeed
        return UITableViewCell()
    }
    
    //You can use the same structure to setup the didSelectRowAt delegate method:
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch items[indexPath.section].type {
//            // do appropriate action for each type
//        case .nameAndPicture:
//            <#code#>
//        case .about:
//            <#code#>
//        case .email:
//            <#code#>
//        case .friend:
//            <#code#>
//        }
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}



//DEFAULT VALUES
extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class ProfileViewModelNonFriendsItem: ProfileViewModelItem{
    var type: ProfileViewModelItemType {
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

//Friend section - MULTIPLE CELLS POSSIBLE
class ProfileViewModelFriendsItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .friend
    }
    var sectionTitle: String {
        return "Friends"
    }
    var rowCount: Int {
        return friends.count //MAKES IT MULTIPLE
    }
    var friends: [Friend]
    init(friends: [Friend]) {
        self.friends = friends
    }
}


