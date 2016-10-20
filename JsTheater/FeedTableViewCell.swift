//
//  FeedTableViewCell.swift
//  JsTheater
//
//  Created by John Park on 10/16/16.
//  Copyright © 2016 illyabbi. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!


    
//        func itemDateLabel(sender: AnyObject) {
//            var time = NSDate()
//            var formatter = NSDateFormatter()
//            formatter.dateFormat = "dd-MM"
//            var formatteddate = formatter.stringFromDate(time)
//            LblTime.text = formatteddate
//        }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
