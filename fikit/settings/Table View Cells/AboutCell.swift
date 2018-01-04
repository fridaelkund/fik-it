//
//  AboutCell.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import UIKit

class AboutCell: UITableViewCell {

    
    @IBOutlet weak var aboutLabel: UILabel!
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard  let item = item as? ProfileViewModelAboutItem else {
//                return
//            }
//            
//            aboutLabel?.text = item.about
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
