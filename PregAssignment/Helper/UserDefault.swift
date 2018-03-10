//
//  UserDefault.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit

class UserDefault: NSObject {
    
    /// Get bookmart list
    ///
    /// - Returns: TweetModel object
    class func getBookmarkList() -> [TweetModel] {
        
        if (UserDefaults.standard.value(forKey: "keyBookmarkList")) != nil
        {
            if let data = UserDefaults.standard.object(forKey: "keyBookmarkList") as? NSData
            {
                let value = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [TweetModel]
                return value
                
            }
        }
        return []
    }
    
    /// set TweetModel array
    ///
    /// - Parameter value: TweetModel array
    class func setBookmarkList(_ value : [TweetModel])
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(data, forKey: "keyBookmarkList")
        UserDefaults.standard.synchronize()
    }
    
}
