//
//  TweetModel.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import Foundation

/// Twitter model
struct TweetModel {
    
    var id: Int = 0
    var title: String = ""
    var description: String = ""
    var screenName: String = ""
    var profilePicUrl: String = ""
    var bannerUrl: String = ""
    var favCount: Int = 0
    var retweetCount: Int = 0
}
