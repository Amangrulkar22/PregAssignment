//
//  BookmarkViewController.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var tableViewBookmark: UITableView!

    /// Array to store bookmark data
    var arrayBookmark : [TweetModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewBookmark.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// define to reload tableview data
        arrayBookmark = UserDefault.getBookmarkList()
        tableViewBookmark.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Action for Bookmark
    ///
    /// - Parameter sender: sender desctiption
    @IBAction func actionToUnheckBookmark(_ sender: Any)
    {
        let button = sender as! UIButton
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeTweet"), object: nil, userInfo: ["id":arrayBookmark[button.tag].id])

        arrayBookmark.remove(at: button.tag)
        UserDefault.setBookmarkList(arrayBookmark)
        self.tableViewBookmark.reloadData()
        
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
        return self.arrayBookmark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetViewCell
        
        cell.bookmarkBtn.tag = indexPath.row
        
        let backgroundImg = "\(self.arrayBookmark[indexPath.row].bannerUrl)"
        if backgroundImg == ""
        {
            cell.bgdImgView.image = #imageLiteral(resourceName: "placeholder")
        }else {
            cell.bgdImgView.setImageFromUrl(urlString: backgroundImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
        }
        
        let tweetLogoImg = "\(self.arrayBookmark[indexPath.row].profilePicUrl)"
        cell.logoImgView.setImageFromUrl(urlString: tweetLogoImg, withPlaceholder: #imageLiteral(resourceName: "placeholder"))
        
        cell.titleLblView.text = "\(self.arrayBookmark[indexPath.row].title)"
        cell.sceenNameLblView.text = "@\(self.arrayBookmark[indexPath.row].screenName)"
        cell.descLblView.text = "\(self.arrayBookmark[indexPath.row].desc)"
        cell.likeCountLblView.text = "\(self.arrayBookmark[indexPath.row].favCount)"
        cell.retweetCountLblView.text = "\(self.arrayBookmark[indexPath.row].retweetCnt)"
        cell.bookmarkBtn.isSelected = true
        
        return cell
    } 
}
