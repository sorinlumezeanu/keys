//
//  MenuVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/23/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {

    private struct Constants {
        static let MenuOptionCellIdentifier = "MenuOptionCell"
        static let DismissMenuSegueId = "DismissMenuSegueId"
    }
    
    var options = [String]()
    private(set) var selectedOption: String?
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MenuOptionCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedOption = options[indexPath.row]
        performSegueWithIdentifier(Constants.DismissMenuSegueId, sender: self)
    }
}
