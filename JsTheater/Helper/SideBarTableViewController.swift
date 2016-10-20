//
//  SideBarTableViewController.swift
//  SideBarControlExample
//

import UIKit

protocol SideBarTableViewControllerDelegate{
    func sideBarControllerDidSelectRow(_ indexPath:IndexPath)
}

class SideBarTableViewController: UITableViewController {
    
    var delegate:SideBarTableViewControllerDelegate?
    var tableData:Array<String> = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            // Configure the cell...
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.darkText
            
            let selectedCellView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            
            selectedCellView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            cell?.selectedBackgroundView = selectedCellView
        }
        
        cell?.textLabel?.text = tableData[(indexPath as NSIndexPath).row]
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  45.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControllerDidSelectRow(indexPath)
    }
    
}
