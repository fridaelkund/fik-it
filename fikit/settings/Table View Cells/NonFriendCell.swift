//
//  NonFriendCell.swift
//  fikit
//
//  Created by Josefine Möller on 2018-01-04.
//

import UIKit

class NonFriendCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    var item: Friend? {
        didSet {
            guard let item = item else {
                return
            }
            
            if let pictureUrl = item.pictureUrl {
                pictureImageView?.image = UIImage(named: pictureUrl)
            }
            
            nameLabel?.text = item.name
        }
    }
    
    @IBAction func addFriendAction(_ sender: UIButton) {
        print(self.item?.name)
        //Now we should add and remove friends from arrays
        
        //self.friends.append(objectArray["Vänner"].sectionObjects[self.item.name])

    }
    
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView?.layer.cornerRadius = 40
        pictureImageView?.clipsToBounds = true
        pictureImageView?.contentMode = .scaleAspectFit
        pictureImageView?.backgroundColor = UIColor.lightGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView?.image = nil
    }
    
}
