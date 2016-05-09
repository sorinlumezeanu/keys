//
//  SelectSystemVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SelectSystemVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private struct Constants {
        static let SelectSystemCellId = "SelectSystemCell"
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var system: SystemVM?
    
    var data = Repository.websites
    var filteredData = [Website]()
    
    private var searchIsActive: Bool {
        return self.searchBar.text != ""
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: UISearchBarDelegate 
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var needle = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        needle = needle.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).joinWithSeparator("")
        filteredData = data.filter( { $0.url.lowercaseString.containsString(needle) })
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchIsActive {
            return self.filteredData.count
        } else {
            return data.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SelectSystemCellId, forIndexPath: indexPath) as!
            SelectSystemCell

        if self.searchIsActive {
            cell.systemLabel.text = filteredData[indexPath.row].name
        } else {
            cell.systemLabel.text = data[indexPath.row].name
        }
        
        return cell
    }
}
