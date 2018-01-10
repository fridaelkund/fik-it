//
//  NamePictureCell.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import UIKit

//NAME AND PROFILE PICTURE CELL

class NamePictureCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            // cast the ProfileViewModelItem to appropriate item type
//            guard let item = item as? ProfileViewModelNameItem  else {
//                return
//            }
//            nameLabel?.text = item.userName
//            pictureImageView?.image = UIImage(named: item.pictureUrl)
//        }
//    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Layout for picture
        pictureImageView?.layer.cornerRadius = 50
        pictureImageView?.clipsToBounds = true
        pictureImageView?.contentMode = .scaleAspectFit
        pictureImageView?.backgroundColor = UIColor.lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView?.image = nil
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
