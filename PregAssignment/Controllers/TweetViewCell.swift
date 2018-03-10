//
//  TweetViewCell.swift
//  PregBuddy
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell
{
    @IBOutlet weak var bgdImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLblView: UILabel!
    @IBOutlet weak var sceenNameLblView: UILabel!
    @IBOutlet weak var descLblView: UILabel!
    @IBOutlet weak var likeCountLblView: UILabel!
    @IBOutlet weak var retweetCountLblView: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /// Set logo image view border and width
        logoImgView.layer.masksToBounds = true
        logoImgView.layer.borderColor = UIColor.black.cgColor
        logoImgView.layer.borderWidth = 2.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
