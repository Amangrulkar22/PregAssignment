//
//  HomeViewController.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import TwitterKit
import SVProgressHUD

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    /// Tweet tableview object
    @IBOutlet weak var tableViewTweets: UITableView!
    
    /// Array to store tweet data
    var arrayTweet : [TweetModel] = []
    
    /// Store page count to fetch twitter data in pagination
    var pageCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Api call for fetching twitter api
        twitterSearchApiCall(page: pageCount)
        
    }
    
    /// API call for fetching twitter search data
    ///
    /// - Parameter page: pagination count
    func twitterSearchApiCall(page: Int) {
        
        SVProgressHUD.show()
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json?q=pregnancy&page=\(page)"
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: nil, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            SVProgressHUD.dismiss()
            
            do {
                if SingletonClass.sharedInstance.isConnectedToNetwork()
                {
                    if data != nil {
                        let json = try JSONSerialization.jsonObject(with: data!) as! [AnyObject]
                        
//                        print("json: \(json)")
                        
                        //Loop to store dictionary of data in array
                        for dict in json
                        {
                            var model = TweetModel()
                            
                            if let id = dict.value(forKey: "id") as? Int {
                                model.id = id
                            }
                            
                            if let title = dict.value(forKey: "name") as? String {
                                model.title = title
                            }
                            
                            if let description = dict.value(forKey: "description") as? String {
                                model.description = description
                            }
                            
                            if let screenName = dict.value(forKey: "screen_name") as? String {
                                model.screenName = screenName
                            }
                            
                            if let bannerUrl = dict.value(forKey: "profile_banner_url") as? String {
                                model.bannerUrl = bannerUrl
                            }
                            
                            if let profileUrl = dict.value(forKey: "profile_image_url") as? String {
                                model.profilePicUrl = profileUrl
                            }
                            
                            if let favCount = dict.value(forKey: "favourites_count") as? Int {
                                model.favCount = favCount
                            }
                            
                            if let retweetCount = dict.value(forKey: "status.retweet_count") as? Int {
                                model.retweetCount = retweetCount
                            }
                            
                            self.arrayTweet.append(model)
                        }
                        
                        self.tableViewTweets.reloadData()
                    }else
                    {
                        print("No Internet connection available")
                    }
                }else {
                    print("Server error")
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Tableview delegate and datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTweet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetViewCell
        
        let backgroundImg = "\(self.arrayTweet[indexPath.row].bannerUrl)"
        if backgroundImg == ""
        {
            cell.bgdImgView.image = #imageLiteral(resourceName: "placeholder")
        }else {
            cell.bgdImgView.setImageFromUrl(urlString: backgroundImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
        }
        
        let tweetLogoImg = "\(self.arrayTweet[indexPath.row].profilePicUrl)"
        cell.logoImgView.setImageFromUrl(urlString: tweetLogoImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
        
        cell.titleLblView.text = "\(self.arrayTweet[indexPath.row].title)"
        cell.sceenNameLblView.text = "@\(self.arrayTweet[indexPath.row].screenName)"
        cell.descLblView.text = "\(self.arrayTweet[indexPath.row].description)"
        cell.likeCountLblView.text = "\(self.arrayTweet[indexPath.row].favCount)"
        cell.retweetCountLblView.text = "\(self.arrayTweet[indexPath.row].retweetCount)"
        
        if (indexPath.row == (self.arrayTweet.count - 1) && pageCount<5)
        {
            // Last cell is visible
            pageCount+=1
            
            twitterSearchApiCall(page: pageCount)
            
            if pageCount > 4  && pageCount<5{
                self.tableViewTweets.tableFooterView?.isHidden = true
                self.tableViewTweets.tableFooterView = nil
            }
            
        }
        
        return cell
    }
}
