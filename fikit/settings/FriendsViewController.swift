//
//  FriendsViewController.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import UIKit

class FriendsViewController: UIViewController {

    //Hämtar data från model
    fileprivate let viewModel = ProfileViewModel()

    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        tableView?.dataSource = viewModel
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        tableView?.register(FriendsCell.nib, forCellReuseIdentifier: FriendsCell.identifier)
        tableView?.register(NonFriendCell.nib, forCellReuseIdentifier: NonFriendCell.identifier)
        
        viewModel.loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FriendsViewController: ProfileViewModelDelegate {
    func didFinishUpdates() {
        self.tableView?.reloadData()

    }
}
