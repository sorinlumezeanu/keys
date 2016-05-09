//
//  SelectRecordTypeVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SelectRecordTypeVC: UITableViewController {

    private struct Constants {
        static let SelectRecordTypeCellId = "SelectRecordTypeCell"
        static let UnwindToChangeRecordTypeSegueId = "UnwindToChangeRecordType"
    }
    
    var selectedOption: Secret.Type5?
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Secret.Type5.allValues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SelectRecordTypeCellId, forIndexPath: indexPath)
        
        let option = Secret.Type5.allValues[indexPath.row]
        cell.textLabel?.text = option.rawValue
        cell.accessoryType = (option == self.selectedOption) ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case Constants.UnwindToChangeRecordTypeSegueId:
            if let selectedCell = sender as? UITableViewCell {
                self.selectedOption = Secret.Type5(rawValue: selectedCell.textLabel!.text!)
            }
            break
            
        default:
            break
        }
    }
}
