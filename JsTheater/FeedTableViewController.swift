//
//  FeedTableViewController.swift
//
//  Created by John Park on 10/15/16.
//  Copyright © 2016 illyabbi. All rights reserved.
//


import UIKit

class FeedTableViewController: UITableViewController, XMLParserDelegate, MWFeedParserDelegate, SideBarDelegate {
    
    var feedItems = [MWFeedItem]()
    var sidebar = SideBar()
    var savedFeeds = [Feed]()
    var feedNames = [String]()
    
    
    
    // xml parser
    var myParser: XMLParser = XMLParser()
    
    // rss records
    var rssRecordList : [RssRecord] = [RssRecord]()
    var rssRecord : RssRecord?
    
    // original var before adding media
    //    var isTagFound = [ "item": false , "title":false, "pubDate": false ,"link":false]
    var isTagFound = [ "item": false , "title":false, "pubDate": false , "media": false , "link":false]
    
    var mediaURL = ""
    
    
    
    //    func request(){
    func request(_ urlString:String?){
        
        if urlString == nil {
            
            
            
            //            let url = NSURL(string: "http://feeds.nytimes.com/nyt/rss/Technology")
            
            
            let url = URL(string: "http://jstheater.blogspot.com/feeds/posts/default?alt=rss")
            //            let url = NSURL(string: "http://www.texanerin.com/feed/")
            let feedParser = MWFeedParser(feedURL: url)
            feedParser?.delegate = self
            feedParser?.parse()
            
        }else{
            let url = URL(string: urlString!)
            let feedParser = MWFeedParser(feedURL: url)
            feedParser?.delegate = self
            feedParser?.parse()
            
        }
    }
    
    func loadSavedFeeds (){
        savedFeeds = [Feed]()
        feedNames = [String]()
        
        feedNames.append("Add Feed")
        
        //        let moc = SwiftCoreDataHelper.managedObjectContext()
        //
        //        let results = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Feed), withPredicate: nil, managedObjectContext: moc)
        //
        //        if results.count > 0 {
        //            for feed in results{
        //                let f = feed as Feed
        //                savedFeeds.append(f)
        //                feedNames.append(f.name)
        //            }
        //        }
        // POSITION XYZ
        
        
    }
    
    
    //MARK: FEED PARSER DELEGATE
    func feedParserDidStart(_ parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info)
        self.title = info.title
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
    
    
    
    //MARK: SIDEBAR DELEGATE
    func sideBarDidSelectMenuButtonAtIndex(_ index: Int) {
        if index == 0{ //ADD FEED BUTTON
            
            let alert = UIAlertController(title: "Add new feed", message: "Enter feed name and URL", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
                textField.placeholder = "feed name"
            })
            
            alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
                textField.placeholder = "feed URL"
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) -> Void in
                let textFields = alert.textFields
                
                let feedNameTextField = (textFields?.first)! as UITextField
                let feedURLTextField = (textFields?.last)! as UITextField
                
                if feedNameTextField.text != "" && feedURLTextField.text != ""{
                    //                    let moc = SwiftCoreDataHelper.managedObjectContext()
                    //
                    //                    let feed = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Feed), managedObjectContext: moc) as Feed
                    //
                    //                    feed.name = feedNameTextField.text
                    //                    feed.url = feedNameTextField.text
                    //
                    //                    SwiftCoreDataHelper.saveManagedObjectContext(moc)
                    
                    self.loadSavedFeeds()
                    
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let moc = SwiftCoreDataHelper.managedObjectContext()
            
            //            let selectedFeed = moc.existingObjectWithID(savedFeeds[index - 1].objectID, error: nil) as Feed
            //
            //            request(selectedFeed.url)
            // vs below "request()"
            request(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MOVED TO POSITION XYZ ONCE DEBUG OF MOC
        // CHANGE "ADD FEED" TO feedNames once DEBUG OF MOC
        //        sidebar = SideBar(sourceView: self.navigationController!.view, menuItems: feedNames)
        sidebar = SideBar(sourceView: self.navigationController!.view, menuItems: ["Hi Curtis!"])
        sidebar.delegate = self
        
        loadSavedFeeds()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load Rss data and parse
        if self.rssRecordList.isEmpty {
            self.loadRSSData()
        }
        
        request(nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssRecordList.count
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        let item = feedItems[(indexPath as NSIndexPath).row] as MWFeedItem?
        cell.itemTitleLabel.text = item?.title
        
        let thisRecord : RssRecord  = self.rssRecordList[(indexPath as NSIndexPath).row]
        cell.itemDateLabel.text = thisRecord.pubDate
        
        //        one method?
        func getImageFromURL(_ fileURL: String) -> UIImage {
            let url = URL(string: mediaURL)!
            let image = UIImage(data: Data(contentsOf: url))!
            return image

        }

        
//        cell.itemImageView.image! = self.getImageFromURL(url)

        //        my original that works
//        cell.itemImageView.setImageWithURL(NSURL(string: mediaURL)!, placeholderImage: UIImage(named: "placeholder"))
        //        cell.itemImageView.image = UIImage(named: "placeholder")
        
        
        //my discovery
        //    }else if elementName == "media:thumbnail" {
        //    self.mediaURL = attributeDict["url"]!
        
        
        //        another method
        let url = URL(string: mediaURL)!
        //        [cell.itemImageView, sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            if (!error) {
        //            cell.itemImageView.image = image
        //            }
        //            }];
        
        
        
        print("xxxxx",mediaURL)
        
        
        
        if item?.content != nil {
            //            let htmlContent = item!.content as NSString
            let imageSource = ""
            //
            //            let rangeOfString = NSMakeRange(0, htmlContent.length)
            //            let regex = try! NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [.CaseInsensitive, .AnchorsMatchLines])
            //
            //            if htmlContent.length > 0 {
            //                let match = regex.firstMatchInString(htmlContent as String, options: [], range: rangeOfString)
            //                if match != nil {
            //                    let imageUrl = htmlContent.substringWithRange((match!.rangeAtIndex(2))) as NSString
            //                    if NSString(string: imageUrl.lowercaseString).rangeOfString("feedburner").location == NSNotFound{
            //                        imageSource = imageUrl as String
            //
            //                    }
            //                }
            //            }
            //
            if imageSource != "" {
                
                cell.itemImageView.setImageWith(URL(string: mediaURL)!, placeholderImage: UIImage(named: "placeholder"))
                print("11111",mediaURL)
                //
            }else{
                cell.itemImageView.image = UIImage(named: "placeholder")
                print("22222",mediaURL)
                
            }
        }
        
        // Configure the cell...
        //        let item = feedItems[indexPath.row] as MWFeedItem
        //        cell.textLabel?.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feedItems[(indexPath as NSIndexPath).row] as MWFeedItem
        
        let webBrowser = KINWebBrowserViewController()
        let url = URL(string: item.link)
        
        webBrowser.load(url)
        
        self.navigationController?.pushViewController(webBrowser, animated: true)
        
    }
    
    
    
    
    // MARK: - NSXML Parse delegate function
    
    // start parsing document
    func parserDidStartDocument(_ parser: XMLParser) {
        // start parsing
    }
    
    // element start detected
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "item" {
            //            postTitle = ""
            //            postLink = ""
            mediaURL = ""
            self.isTagFound["item"] = true
            self.rssRecord = RssRecord()
            
        }else if elementName == "title" {
            self.isTagFound["title"] = true
            
        }else if elementName == "link" {
            self.isTagFound["link"] = true
            
        }else if elementName == "pubDate" {
            self.isTagFound["pubDate"] = true
            
        }else if elementName == "media:thumbnail" {
            self.mediaURL = attributeDict["url"]!
            
        }
//        return self.mediaURL
    }
    
    // characters received for some element
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isTagFound["title"] == true {
            self.rssRecord?.title += string
            
        }else if isTagFound["link"] == true {
            self.rssRecord?.link += string
            
        }else if isTagFound["pubDate"] == true {
            self.rssRecord?.pubDate += string
            
            //        }else if isTagFound["media:thumbnail"] == true {
            //            self.rssRecord?.mediaURL += string
            
        }
        
    }
    
    // element end detected
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            
            // From asdf
            //            let post = Post()
            //            post.pMediaURL = mediaURL
            //            postsArray.append(post)
            
            self.isTagFound["item"] = false
            self.rssRecordList.append(self.rssRecord!)
            
        }else if elementName == "title" {
            self.isTagFound["title"] = false
            
        }else if elementName == "link" {
            self.isTagFound["link"] = false
            
        }else if elementName == "pubDate" {
            self.isTagFound["pubDate"] = false
            
            //        }else if elementName == "media:thumbnail" {
            //            self.isTagFound["url"] = false
        }
        print("IIIIIIIIIII",mediaURL)
    }
    
    // end parsing document
    func parserDidEndDocument(_ parser: XMLParser) {
        
        //reload table view
        //        self.myTableView.reloadData()
        
        // stop spinner
        //        self.spinner.stopAnimating()
    }
    
    // if any error detected while parsing.
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
        //  stop animation
        //        self.spinner.stopAnimating()
        
        // show error message
        //        self.showAlertMessage(alertTitle: "Error", alertMessage: "Error while parsing xml.")
        //          tied to line #396-415 below
    }
    
    
    
    
    // MARK: - Utility functions
    
    // load rss and parse it
    fileprivate func loadRSSData(){
        
        if let rssURL = URL(string: RSS_FEED_URL) {
            
            // start spinner
            //            self.spinner.startAnimating()
            
            // fetch rss content from url
            self.myParser = XMLParser(contentsOf: rssURL)!
            
            // set parser delegate
            self.myParser.delegate = self
            self.myParser.shouldResolveExternalEntities = false
            
            // start parsing
            self.myParser.parse()
        }
        
    }
    
    // show alert with ok button
    //    private func showAlertMessage(alertTitle alertTitle: String, alertMessage: String ) -> Void {
    //
    //        // create alert controller
    //        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert) as UIAlertController
    //
    //        // create action
    //        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:
    //            { (action: UIAlertAction) -> Void in
    //                // you can add code here if needed
    //        })
    //
    //        // add ok action
    //        alertCtrl.addAction(okAction)
    //
    //        // present alert
    //        self.presentViewController(alertCtrl, animated: true, completion: { (void) -> Void in
    //            // you can add code here if needed
    //        })
    //    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    //        if segue.identifier == "segueShowDetails" {
    
    // find index path for selected row
    //            let selectedIndexPath : [NSIndexPath] = self.myTableView.indexPathsForSelectedRows!
    
    // deselect the selected row
    //            self.myTableView.deselectRowAtIndexPath(selectedIndexPath[0], animated: true)
    
    // create destination view controller
    //            let destVc = segue.destinationViewController as! DetailsViewController
    
    // set title for next screen
    //            destVc.navigationItem.title = self.rssRecordList[selectedIndexPath[0].row].title
    
    // set media for next screen
    //            destVc.navigationItem.media = self.rssRecordList[selectedIndexPath[0].row].media
    
    // set link value for destination view controller
    //            destVc.link = self.rssRecordList[selectedIndexPath[0].row].link
    
    //        }
    
    //    }
    
    
    
    
}
