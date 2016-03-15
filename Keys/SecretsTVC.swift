//
//  SecretsTVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/3/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretsTVC: UITableViewController {
    
    struct Constants {
        static let VaultTableCellIdentifier = "VaultTableCellIdentifier"
        static let AddVaultSegueId = "AddVault2"
    }
    
    @IBAction func cancelAddVault(segue: UIStoryboardSegue) {
        print("cancelAddVault")
    }
    
    @IBAction func saveAddVault(segue: UIStoryboardSegue) {
        let addVaultVC = segue.sourceViewController as! AddVaultTVC
        SecurityContext.sharedInstance.setPassphraseForVault(addVaultVC.vault, passphrase: addVaultVC.password)
        Repository.addVaultFile(VaultFile(withVault: addVaultVC.vault))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.vaultFiles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.VaultTableCellIdentifier, forIndexPath: indexPath) as! SettingsTVCell

        let vaultFile = Repository.vaultFiles[indexPath.row]
        let vault = vaultFile.vault!
        
        cell.vaultName?.text = vault.description
        cell.vaultSummary?.text = vault.summary

        return cell
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
