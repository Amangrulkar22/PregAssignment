//
//  TweetModel.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import Foundation

/// Twitter model

class TweetModel: NSObject,NSCoding {
    
    var id: Int = 0
    var title: String = ""
    var desc: String = ""
    var screenName: String = ""
    var profilePicUrl: String = ""
    var bannerUrl: String = ""
    var favCount: Int = 0
    var retweetCnt: Int = 0
    var isBookmark: Bool = false
    
    /// Initialization of variable
    init(id: Int, title: String, desc: String, screenName: String, profilePicUrl: String, bannerUrl: String, favCount: Int, retweetCnt: Int, isBookmark: Bool) {
        self.id = id
        self.title = title
        self.desc = desc
        self.screenName = screenName
        self.profilePicUrl = profilePicUrl
        self.bannerUrl = bannerUrl
        self.favCount = favCount
        self.retweetCnt = retweetCnt
        self.isBookmark = isBookmark
    }
    
    /// Decoder of variable
    ///
    /// - Parameter decoder: decoder description
    required convenience init(coder decoder: NSCoder) {
        
        let id = decoder.decodeInteger(forKey: "id")
        let title = decoder.decodeObject(forKey: "title") as? String ?? ""
        let desc = decoder.decodeObject(forKey: "desc") as? String ?? ""
        let screenName = decoder.decodeObject(forKey: "screenName") as? String ?? ""
        let profilePicUrl = decoder.decodeObject(forKey: "profilePicUrl") as? String ?? ""
        let bannerUrl = decoder.decodeObject(forKey: "bannerUrl") as? String ?? ""
        let favCount = decoder.decodeInteger(forKey: "favCount")
        let retweetCnt = decoder.decodeInteger(forKey: "retweetCnt")
        let isBookmark = decoder.decodeBool(forKey: "isBookmark")
        
        self.init(id: id, title: title, desc: desc, screenName: screenName, profilePicUrl: profilePicUrl, bannerUrl: bannerUrl, favCount: favCount, retweetCnt: retweetCnt, isBookmark: isBookmark)
    }
    
    /// Encoder of variable
    ///
    /// - Parameter coder: coder description
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "desc")
        coder.encode(screenName, forKey: "screenName")
        coder.encode(profilePicUrl, forKey: "profilePicUrl")
        coder.encode(bannerUrl, forKey: "bannerUrl")
        coder.encode(favCount, forKey: "favCount")
        coder.encode(retweetCnt, forKey: "retweetCnt")
        coder.encode(isBookmark, forKey: "isBookmark")
    }
}
