//
//  VaultTVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/16/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class VaultTVC: UITableViewController {

    private struct Constants {
        static let SecretCellIdentifier = "SecretCellIdentifier"
        static let AddSecretCellIdentifier = "AddSecretCellIdentifier"
        static let AddSecretSegueId = "AddSecretSegueId"
    }
    
    var vault: Vault!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.navigationItem.title = vault.name
    }
    
    @IBAction func addRecord() {
        self.performSegueWithIdentifier(Constants.AddSecretSegueId, sender: self)
    }
    
    @IBAction func saveAddSecret(segue: UIStoryboardSegue) {
        if let secret = (segue.sourceViewController as? AddSecretVC)?.secret {
            self.vault.addSecret(secret)
            self.tableView.reloadData()
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vault.secrets.count + 1     // the last one is for the 'Add Secret' cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case let row where row < self.vault.secrets.count:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SecretCellIdentifier, forIndexPath: indexPath)
            let secret = self.vault.secrets[row]
            cell.textLabel?.text = secret.description
            return cell

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.AddSecretCellIdentifier, forIndexPath: indexPath)            
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
