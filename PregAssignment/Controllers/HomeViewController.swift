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
    
    @IBOutlet weak var customFilterView: UIView!
    @IBOutlet weak var mostLiketbtn: UIButton!
    @IBOutlet weak var mostRetweettbtn: UIButton!
    @IBOutlet weak var heightConstraintForview: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintForView: NSLayoutConstraint!
    
    /// Array to store tweet data
    var arrayTweet : [TweetModel] = []
    
    /// Filter Array to store tweet data
    var filterArrayTweet : [TweetModel] = []
    
    
    /// Store page count to fetch twitter data in pagination
    var pageCount: Int = 1
    
    var isFilterApply: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initialLoad()
        
        //Api call for fetching twitter api
        twitterSearchApiCall(page: pageCount)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeObjectFromArray), name: NSNotification.Name(rawValue: "removeTweet"), object: nil)
    }
    
    /// Initial load view
    func initialLoad()
    {
        self.heightConstraintForview.constant = minConstantVal
        self.widthConstraintForView.constant = minConstantVal
        tableViewTweets.tableFooterView = UIView()
    }
    
    /// Notification callback method to remove record from array
    ///
    /// - Parameter object: tweet id
    func removeObjectFromArray(object:NSNotification) {
        
        guard let userInfo = object.userInfo,let id = userInfo["id"] as? Int else
        {
            //print("No userInfo found in notification")
            return
        }
        
        /// Update bookmart item from main array
        var indexCount = 0
        for value:TweetModel in arrayTweet
        {
            if value.id == id {
                break
            }
            indexCount+=1
        }
        
        let tempTweet = arrayTweet[indexCount]
        tempTweet.isBookmark = false
        tableViewTweets.reloadData()
        
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
                            let model = TweetModel(id: 0, title: "", desc: "", screenName: "", profilePicUrl: "", bannerUrl: "", favCount: 0, retweetCnt: 0, isBookmark: false)
                            
                            if let id = dict.value(forKey: "id") as? Int {
                                model.id = id
                            }
                            
                            if let title = dict.value(forKey: "name") as? String {
                                model.title = title
                            }
                            
                            if let description = dict.value(forKey: "description") as? String {
                                model.desc = description
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
                            
                            if let retweetCount = dict.value(forKeyPath: "status.retweet_count") as? Int {
                                model.retweetCnt = retweetCount
                            }
                            
                            self.arrayTweet.append(model)
                        }
                        
                        self.tableViewTweets.reloadData()
                    }else
                    {
                        CustomAlertView.showNegativeAlert("Server Error")
                    }
                }else {
                    CustomAlertView.showNegativeAlert("No Internet connection available")
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
    
    /// Check uncheck filter
    ///
    /// - Parameter sender: sender description
    @IBAction func selectFliterMenu(_ sender: Any)
    {
        let button = sender as! UIButton
        
        switch button.tag {
        case 0:
            mostLiketbtn.isSelected = !mostLiketbtn.isSelected
            
        case 1:
            mostRetweettbtn.isSelected = !mostRetweettbtn.isSelected
            
        default: break
            
        }
        
    }
    
    @IBAction func showFilterPopUp(_ sender: Any)
    {
        if self.heightConstraintForview.constant == 0
        {
            self.heightConstraintForview.constant = maxConstantVal
            self.widthConstraintForView.constant = maxConstantVal
            UIView.animate(withDuration: 0.30) {
                self.view.layoutIfNeeded()
            }
        }else
        {
            self.initialLoad()
            UIView.animate(withDuration: 0.30) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// Filter apply button action
    ///
    /// - Parameter sender: Sender description
    @IBAction func actionForApplyFilter(_ sender: Any)
    {
        if mostLiketbtn.isSelected && mostRetweettbtn.isSelected
        {
            //by favourite count
            let sortedFavArray = arrayTweet.sorted { $0.favCount > $1.favCount }
            
            //by retweet count
            let sortedArray = sortedFavArray.sorted { $0.retweetCnt > $1.retweetCnt }
            
            filterArrayTweet = sortedArray
            
            isFilterApply = true
            
        }else if mostLiketbtn.isSelected
        {
            //by favourite count
            let sortedFavArray = arrayTweet.sorted { $0.favCount > $1.favCount }
            
            filterArrayTweet = sortedFavArray
            
            isFilterApply = true
            
        }else if mostRetweettbtn.isSelected
        {
            //by retweet count
            let sortedArray = arrayTweet.sorted { $0.retweetCnt > $1.retweetCnt }
            
            filterArrayTweet = sortedArray
            
            isFilterApply = true
            
        }else {
            isFilterApply = false
        }
        
        self.tableViewTweets.reloadData()
        
        self.initialLoad()
        UIView.animate(withDuration: 0.30) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    /// Action bookmart method
    ///
    /// - Parameter sender: sender description
    @IBAction func actionToCheckBookmark(_ sender: Any)
    {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        
        var model:TweetModel!

        /// Check for selection
        if button.isSelected
        {
            if !isFilterApply {
                model = arrayTweet[button.tag]
            }else {
                model = filterArrayTweet[button.tag]
            }
            model.isBookmark = true
            
            var tempArray:[TweetModel] = UserDefault.getBookmarkList()
            tempArray.append(model)
            
            UserDefault.setBookmarkList(tempArray)
            
            CustomAlertView.showPositiveAlert("Bookmark added")
            
        }else
        {
            var tweetList: [TweetModel] = UserDefault.getBookmarkList()
            
            var index = 0
            if tweetList.count > 0
            {
                var outer: TweetModel!
                
                if !isFilterApply {
                    outer = arrayTweet[button.tag]
                }else {
                    outer = filterArrayTweet[button.tag]
                }
                outer.isBookmark = false
                
                for inner:TweetModel in UserDefault.getBookmarkList()
                {
                    if outer.id == inner.id
                    {
                        break;
                    }
                    index+=1
                }
                
                tweetList.remove(at: index)
                UserDefault.setBookmarkList(tweetList)
            }
        }
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
        
        if isFilterApply && filterArrayTweet.count > 0 {
            return 10
            
        }else {
            return self.arrayTweet.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetViewCell
        
        if !isFilterApply
        {
            cell.bookmarkBtn.tag = indexPath.row
            
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
            cell.descLblView.text = "\(self.arrayTweet[indexPath.row].desc)"
            cell.likeCountLblView.text = "\(self.arrayTweet[indexPath.row].favCount)"
            cell.retweetCountLblView.text = "\(self.arrayTweet[indexPath.row].retweetCnt)"
            
            if self.arrayTweet[indexPath.row].isBookmark {
                cell.bookmarkBtn.isSelected = true
            }else{
                cell.bookmarkBtn.isSelected = false
            }
        }else {
            cell.bookmarkBtn.tag = indexPath.row
            
            let backgroundImg = "\(self.filterArrayTweet[indexPath.row].bannerUrl)"
            if backgroundImg == ""
            {
                cell.bgdImgView.image = #imageLiteral(resourceName: "placeholder")
            }else {
                cell.bgdImgView.setImageFromUrl(urlString: backgroundImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
            }
            
            let tweetLogoImg = "\(self.filterArrayTweet[indexPath.row].profilePicUrl)"
            cell.logoImgView.setImageFromUrl(urlString: tweetLogoImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
            
            cell.titleLblView.text = "\(self.filterArrayTweet[indexPath.row].title)"
            cell.sceenNameLblView.text = "@\(self.filterArrayTweet[indexPath.row].screenName)"
            cell.descLblView.text = "\(self.filterArrayTweet[indexPath.row].desc)"
            cell.likeCountLblView.text = "\(self.filterArrayTweet[indexPath.row].favCount)"
            cell.retweetCountLblView.text = "\(self.filterArrayTweet[indexPath.row].retweetCnt)"
            
            if self.filterArrayTweet[indexPath.row].isBookmark {
                cell.bookmarkBtn.isSelected = true
            }else{
                cell.bookmarkBtn.isSelected = false
            }
        }
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
