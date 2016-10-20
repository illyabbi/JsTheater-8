//
//  Js Theater
//
//  Created by John Park on 10/6/16.
//  Copyright © 2016 illyabbi. All rights reserved.
//



import Foundation


class RssRecord {

    var title: String
    var description: String
    var link: String
    var pubDate: String
    var media: String
    var thumbnail: UIImage?
    
    init(){
        self.title = ""
        self.description = ""
        self.link = ""
        self.pubDate = ""
        self.media = ""
    }
        
//    init(thumbnail:UIImage){
//        self.thumbnail = thumbnail
//    }
}


//if let path = info[UIImagePickerControllerMediaURL] as? NSURL {
//    self.thumbnail = path
//    let url = path
//}