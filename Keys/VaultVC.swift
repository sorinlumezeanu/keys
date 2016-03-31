//
//  VaultTVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/16/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class VaultVC: UITableViewController {

    private struct Constants {
        static let SecretCellIdentifier = "SecretCellIdentifier"
        static let AddSecretCellIdentifier = "AddSecretCellIdentifier"
        static let AddSecretSegueId = "AddSecretSegueId"
    }
    
    var vaultFile: VaultFile!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = vaultFile.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setEditing(self.editing, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.leftBarButtonItems = []
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if self.editing {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonTapped:")]
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonTapped:")]
        } else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonTapped:")]
            self.navigationItem.leftBarButtonItems = []
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addRecord() {
        self.performSegueWithIdentifier(Constants.AddSecretSegueId, sender: self)
    }
    
    @IBAction func saveAddSecret(segue: UIStoryboardSegue) {
        if let secret = (segue.sourceViewController as? AddSecretVC)?.secret {
            self.vaultFile.vault.append(secret: secret)
            if !self.editing {
                self.vaultFile.vault.commitChanges()
                self.vaultFile.save()
            }
            self.tableView.reloadData()
        }
    }

    func editButtonTapped(sender: UIBarButtonItem) {
        self.setEditing(true, animated: true)
    }

    func doneButtonTapped(sender: UIBarButtonItem) {
        self.setEditing(false, animated: true)
        self.vaultFile.vault.commitChanges()
        self.vaultFile.save()
    }
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        self.vaultFile.vault.discardChanges()
        self.setEditing(false, animated: true)
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: 1)), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vaultFile.vault.secrets.count + 1     // the last one is for the 'add record' cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case let row where row < self.vaultFile.vault.secrets.count:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SecretCellIdentifier, forIndexPath: indexPath) as! SecretCell
            let secret = self.vaultFile.vault.secrets[row]
            cell.textLabel?.text = secret.description
            cell.secret = secret
            return cell

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.AddSecretCellIdentifier, forIndexPath: indexPath)            
            return cell
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row < self.vaultFile.vault.secrets.count ? true : false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let cellToDelete = self.tableView.cellForRowAtIndexPath(indexPath) as? SecretCell {
                self.vaultFile.vault.remove(secret: cellToDelete.secret!)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let cellToMove = self.tableView.cellForRowAtIndexPath(fromIndexPath) as! SecretCell
        self.vaultFile.vault.move(secret: cellToMove.secret!, toIndex: toIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.row < self.vaultFile.vault.secrets.count {
            return proposedDestinationIndexPath
        }
        else {
            return NSIndexPath(forRow: max(self.vaultFile.vault.secrets.count - 1, 0), inSection: 0)
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row < self.vaultFile.vault.secrets.count ? true : false
    }
}
