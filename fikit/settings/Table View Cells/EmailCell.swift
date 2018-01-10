//
//  EmailCell.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import UIKit

class EmailCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard let item = item as? ProfileViewModelEmailItem else {
//                return
//            }
//            
//            emailLabel?.text = item.email
//        }
//    }
//    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
