//
//  SecretsTVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/3/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class VaultsVC: UITableViewController {
    
    struct Constants {
        static let VaultTableCellIdentifier = "VaultTableCellIdentifier"
        static let AddVaultSegueId = "AddVault2"
        static let ShowVaultSegueId = "ShowVault"
        static let ShowZeroVaultsSegueId = "ShowZeroVaultsVC"
        static let ShowGetPassphraseSegueId = "ShowGetPassphraseVC"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
    }
    
    func setup() {
        if Repository.vaultFiles.count == 0 {
            performSegueWithIdentifier(Constants.ShowZeroVaultsSegueId, sender: self)
            return
        }
        
        if Repository.countUnlockedVaultFiles() == 0 {
            performSegueWithIdentifier(Constants.ShowGetPassphraseSegueId, sender: self)
        }
    }
    
    @IBAction func dismissGetPassphraseVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func cancelAddVault(segue: UIStoryboardSegue) {
        print("cancelAddVault")
    }
    
    @IBAction func saveAddVault(segue: UIStoryboardSegue) {
        let addVaultVC = segue.sourceViewController as! AddVaultTVC
        SecurityContext.sharedInstance.setPassphraseForVault(addVaultVC.vault, passphrase: addVaultVC.password)
        let vaultFile = VaultFile(withVault: addVaultVC.vault)
        Repository.addVaultFile(vaultFile)
        vaultFile.save()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.VaultTableCellIdentifier, forIndexPath: indexPath) as! VaultCell

        let vaultFile = Repository.vaultFiles[indexPath.row]
        cell.setup(vaultFile)
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case Constants.AddVaultSegueId:
            break
        case Constants.ShowVaultSegueId:
            if let selectedVaultCell = sender as? VaultCell {
                if let vaultVC = segue.destinationViewController as? VaultVC {
                    vaultVC.vaultFile = selectedVaultCell.vaultFile
                }
            }
            break
        default:
            break
        }
    }

}
