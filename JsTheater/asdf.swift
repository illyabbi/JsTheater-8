////
////  Home.swift
////  TVS Assembly App
////
////  Created by Cole Fortson on 15/09/15.
////  Copyright (c) 2015 Cole Fortson. All rights reserved.
////
//
//import UIKit
//import AudioToolbox
////import iAd
//
//
//
//class Home: UIViewController,
//    NSXMLParserDelegate,
//    UICollectionViewDataSource,
//    UICollectionViewDelegate,
//    UICollectionViewDelegateFlowLayout
//    //ADBannerViewDelegate,
//    //GADBannerViewDelegate
//{
//    
//    /* Views */
//    @IBOutlet weak var postsCollView: UICollectionView!
//    @IBOutlet weak var categoriesScrollView: UIScrollView!
//    var catButton = UIButton()
//    
//    //Ad banners properties
//    //  var iAdBannerView = ADBannerView()
//    // var adMobBannerView = GADBannerView()
//    
//    
//    
//    
//    /* Variables */
//    var parser = NSXMLParser()
//    var postsArray : [Post] = []
//    var categoryName = ""
//    
//    var postTitle = ""
//    var postLink = ""
//    var mediaURL = ""
//    var elementStr = ""
//    
//    var cellSize = CGSize()
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Show HUD
//        view.showHUD(view)
//        
//        
//        // Call a method to create Category Buttons
//        createCategoryButtons()
//        
//        
//        // Resize post cells accordingly to the Device used
//        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
//            // iPhone
//            cellSize = CGSizeMake(view.frame.size.width/2, 160)
//        } else  {
//            // iPad
//            cellSize = CGSizeMake(view.frame.size.width/3, 160)
//        }
//        
//        
//        // Call the RSS parsing function with the 1st Category
//        parseRSSfeeds("\(categoriesArray[0])")
//        print("Category: \(categoriesArray[0])")
//        
//        
//        // Init ad banners
//        // initiAdBanner()
//        // initAdMobBanner()
//    }
//    
//    
//    
//    
//    // MARK: - CREATE CATEGORY MENU
//    func createCategoryButtons() {
//        // Variables
//        var xCoord: CGFloat = 0
//        let yCoord: CGFloat = 5
//        let buttonWidth:CGFloat = 80
//        let buttonHeight: CGFloat = 40
//        let gapBetweenButtons: CGFloat = 0
//        
//        // Counter
//        var itemCount = 0
//        
//        // Loop for creating buttons -------------------------------
//        for itemCount = 0;  itemCount < categoriesArray.count;  itemCount++ {
//            catButton = UIButton(type: UIButtonType.Custom)
//            catButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
//            catButton.tag = itemCount + 100
//            catButton.showsTouchWhenHighlighted = true
//            catButton.setTitle("\(categoriesArray[itemCount])", forState: UIControlState.Normal)
//            catButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
//            catButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//            catButton.backgroundColor = colorsArray[itemCount]
//            catButton.addTarget(self, action: "catButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
//            
//            if catButton.tag == 100 { catButton.frame.origin.y = 0 }
//            
//            // Add Buttons based on xCood
//            xCoord +=  buttonWidth + gapBetweenButtons
//            categoriesScrollView.addSubview(catButton)
//        } // END LOOP ----------------------------------------------
//        
//        
//        // Place Buttons into the ScrollView
//        categoriesScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount), yCoord)
//    }
//    
//    
//    
//    
//    // MARK: - CATEGORY BUTTON
//    func catButtTapped(sender:UIButton) {
//        let butt = sender as UIButton
//        let bkgColor = butt.backgroundColor
//        view.showHUD(view)
//        hudView.backgroundColor = bkgColor
//        
//        postsArray.removeAll()
//        postsCollView.reloadData()
//        
//        // Move selected button up
//        for var i = 100;  i < categoriesArray.count + 100;  i++ {
//            view.viewWithTag(i)!.frame.origin.y = 5
//        }
//        butt.frame.origin.y = 0
//        
//        // Get buttons' title
//        categoryName = "\(butt.titleLabel!.text!)"
//        
//        // Recall RSS parsing
//        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "recallRSSparsing", userInfo: nil, repeats: false)
//        
//    }
//    
//    func recallRSSparsing() {  parseRSSfeeds(categoryName)  }
//    
//    
//    
//    
//    
//    
//    
//    // MARK: - PARSE ALL RSS FEEDS (see Configs.swift file)
//    func parseRSSfeeds(category:String) {
//        let dictRoot = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("RSSlist", ofType: "plist")!)
//        let rssList = dictRoot?.objectForKey(category) as! NSArray
//        
//        for var i = 0;  i < rssList.count;  i++ {
//            let rssURL = NSURL(string: "\(rssList[i])")
//            parser = NSXMLParser(contentsOfURL: rssURL!)!
//            parser.delegate = self
//            parser.parse()
//        }
//    }
//    
//    
//    // MARK: - XML PARSER DEELEGATES
//    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        elementStr = elementName
//        
//        if elementName == "item" {
//            postTitle = ""
//            postLink = ""
//            mediaURL = ""
//        }
//        
//        if elementName == "media:thumbnail" {
//            mediaURL = attributeDict["url"]!
//        }
//    }
//    
//    
//    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        let charData = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        
//        if (!charData.isEmpty) {
//            if elementStr == "title" { postTitle += charData }
//            if elementStr == "link"  { postLink += charData  }
//            
//        }
//        
//    }
//    
//    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        
//        if elementName == "item" {
//            let post = Post()
//            
//            post.pPostTitle = postTitle
//            post.pPostLink = postLink
//            post.pMediaURL = mediaURL
//            
//            // Add elements to the postsArray
//            postsArray.append(post)
//        }
//        
//        
//        // Shuffle the list of posts & reload data
//        postsArray.shuffle()
//        postsCollView.reloadData()
//        postsCollView.setContentOffset(CGPointZero, animated:true)
//        
//        // Hide HUD
//        view.hideHUD(view)
//    }
//    
//    
//    
//    
//    // MARK: - COLLECTION VIEW DELEGATES
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return postsArray.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
//        
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
//            
//            let post: Post = self.postsArray[indexPath.row]
//            
//            // Get Post Title
//            cell.titleLabel.text = post.pPostTitle
//            
//            // Get post image
//            if post.pMediaURL != "" {
//                let url = NSURL(string: post.pMediaURL)
//                if let data = NSData(contentsOfURL: url!) {
//                    cell.postImage.image = UIImage(data: data)
//                }
//            }
//            // Place an app logo where there are no images on an RSS post
//            if cell.postImage.image == nil {
//                cell.postImage.image = UIImage(named: "logo")
//            }
//            
//            
//            // Get Journal's name
//            if post.pPostLink.hasPrefix("http://www.trinityvalleyschool.org/") {
//                cell.journalLabel.text = "NEWS - Read more..."
//            } else if post.pPostLink.hasPrefix("http://thetrojantimes.com/") {
//                cell.journalLabel.text = "NEWSPAPER - Read more..."
//            } else if post.pPostLink.hasPrefix("http://forbes.com") {
//                cell.journalLabel.text = "FORBES"
//            } else if post.pPostLink.hasPrefix("http://rss.cnn.com") {
//                cell.journalLabel.text = "CNN"
//            } else if post.pPostLink.hasPrefix("http://telegraph.feedsportal.com") {
//                cell.journalLabel.text = "THE TELEGRAPH"
//            } else if post.pPostLink.hasPrefix("http://news.google.com/news/") {
//                cell.journalLabel.text = "GOOGLE"
//            }
//            
//            
//        })
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return cellSize
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PostCell
//        
//        let post = postsArray[indexPath.row] as Post
//        
//        let adVC = storyboard?.instantiateViewControllerWithIdentifier("ArticleDetails") as! ArticleDetails
//        
//        // Get all strings to be passed to the next controller
//        adVC.urlString = post.pPostLink
//        adVC.postTitle = post.pPostTitle
//        adVC.journalName = cell.journalLabel.text!
//        adVC.mediaURL = post.pMediaURL
//        
//        adVC.postObj = post
//        
//        navigationController?.pushViewController(adVC, animated: true)
//        
//    }
//    
//    
//    
//    
//    
//    // MARK: - REFRESH RSS BUTTON
//    @IBAction func refreshButt(sender: AnyObject) {
//        view.showHUD(view)
//        postsArray.removeAll(keepCapacity: true)
//        parseRSSfeeds(categoryName)
//    }
//    
//    
//    
//    
//    
//    
//    // MARK: - iAd + AdMob BANNERS
//    
//    // Initialize Apple iAd banner
//    //    func initiAdBanner() {
//    //        iAdBannerView = ADBannerView(frame: CGRectMake(0, view.frame.size.height, 0, 0) )
//    //        iAdBannerView.delegate = self
//    //        iAdBannerView.hidden = true
//    //        view.addSubview(iAdBannerView)
//    //    }
//    //
//    //    // Initialize Google AdMob banner
//    //    func initAdMobBanner() {
//    //        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSizeMake(320, 50))
//    //        adMobBannerView.frame = CGRectMake(0, view.frame.size.height, 320, 50)
//    //        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
//    //        adMobBannerView.rootViewController = self
//    //        adMobBannerView.delegate = self
//    //        view.addSubview(adMobBannerView)
//    //
//    //        let request = GADRequest()
//    //        adMobBannerView.loadRequest(request)
//    //    }
//    
//    
//    // Hide the banner
//    func hideBanner(banner: UIView) {
//        UIView.beginAnimations("hideBanner", context: nil)
//        banner.frame = CGRectMake(0, view.frame.size.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
//        UIView.commitAnimations()
//        banner.hidden = true
//        
//    }
//    
//    // Show the banner
//    func showBanner(banner: UIView) {
//        UIView.beginAnimations("showBanner", context: nil)
//        banner.frame = CGRectMake(0, view.frame.size.height - banner.frame.size.height,
//                                  banner.frame.size.width, banner.frame.size.height);
//        UIView.commitAnimations()
//        banner.hidden = false
//        
//    }
//    
//    //    // iAd banner available
//    //    func bannerViewWillLoadAd(banner: ADBannerView!) {
//    //        print("iAd loaded!")
//    //        hideBanner(adMobBannerView)
//    //        showBanner(iAdBannerView)
//    //    }
//    //    
//    //    // NO iAd banner available
//    //    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//    //        print("iAd can't load ads right now, they'll be available later")
//    //        hideBanner(iAdBannerView)
//    //        let request = GADRequest()
//    //        adMobBannerView.loadRequest(request)
//    //    }
//    //    
//    //    
//    //    // AdMob banner available
//    //    func adViewDidReceiveAd(view: GADBannerView!) {
//    //        print("AdMob loaded!")
//    //        hideBanner(iAdBannerView)
//    //        showBanner(adMobBannerView)
//    //    }
//    //    
//    //    // NO AdMob banner available
//    //    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
//    //        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
//    //        hideBanner(adMobBannerView)
//    //    }
//    //    
//    //
//    
//    
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//}
//
//
//
