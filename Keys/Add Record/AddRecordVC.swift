//
//  AddRecordVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/20/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddRecordVC: UITableViewController {
    
    private struct Constants {
        static let ShowSelectRecordTypeSegueId = "ShowSelectRecordType"
        static let ShowSelectSystemSegueId = "ShowSelectSegue"
    }
    
    private var records: [Secret.Type5: RecordVM] = [:]
    private var activeRecord: RecordVM!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.records[.Login] = RecordVM(addRecordVC: self, secret: Secret.createWithType(.Login))
        self.records[.Note] = RecordVM(addRecordVC: self, secret: Secret.createWithType(.Note))
        self.records[.Other] = RecordVM(addRecordVC: self, secret: Secret.createWithType(.Other))
        self.activeRecord = self.records[.Login]
        
        // weired: the only way to change the title of the Back button for view-controllers that get segued-to (i.e. pushed) from this view controller
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.activeRecord.heightForRowAtIndexPath(indexPath)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.activeRecord.numberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activeRecord.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.activeRecord.prepareCell(indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            
        case Constants.ShowSelectRecordTypeSegueId:
            if let selectRecordTypeVC = segue.destinationViewController as? SelectRecordTypeVC {
                selectRecordTypeVC.selectedOption = self.activeRecord.secret.type
            }
            
        case Constants.ShowSelectSystemSegueId:
            guard let systemField = self.activeRecord.secret[.System]?.first else { break }
            guard let selectSystemVC = segue.destinationViewController as? SelectSystemVC else { break }
            selectSystemVC.system = SystemVM(displayText: systemField.value, photo: systemField.image)
            
        default:
            break
        }
    }

    @IBAction func changeRecordType(segue: UIStoryboardSegue) {
        guard let selectRecordTypeVC = segue.sourceViewController as? SelectRecordTypeVC else { return }
        guard let selectedOption = selectRecordTypeVC.selectedOption else { return }
        
        if selectRecordTypeVC.selectedOption != self.activeRecord.secret.type {
            self.activeRecord = self.records[selectedOption]
            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: self.activeRecord.numberOfSections)), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    @IBAction func saveSelectSystem(segue: UIStoryboardSegue) {
        
    }
}
