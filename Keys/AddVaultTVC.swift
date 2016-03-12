//
//  AddVaultTVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddVaultTVC: UITableViewController {

    struct Constants {
        static let CancelAddVaultSegueId = "CancelAddVault"
        static let SaveAddVaultSegueId = "SaveAddVault"
    }
    
    @IBOutlet weak var vaultNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var passwordErrorCell: UITableViewCell!
    
    private (set) var vault: Vault!
    private (set) var password: String!
    
    private var showPasswordErrorCell = false
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return CGFloat(44)
        case (1, let row) where row == 0:
            return CGFloat(72)
        case (1, let row) where row == 1:
            return showPasswordErrorCell ? CGFloat(44) : CGFloat(0)
        case (1, _):
            return CGFloat(44)
        default:
            return CGFloat(44)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            vaultNameTextField.becomeFirstResponder()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch (identifier) {
        case Constants.CancelAddVaultSegueId:
            return true
        case Constants.SaveAddVaultSegueId:
            return validateUserInput()
        default:
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case Constants.CancelAddVaultSegueId:
            vault = nil
        case Constants.SaveAddVaultSegueId:
            gatherUserInput()            
        default:
            break;
        }
    }
    
    private func validateUserInput() -> Bool {
        guard vaultNameTextField.text != nil else { return false }
        guard vaultNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count > 0 else { return false }

        guard passwordTextField.text != nil else { return false }
        guard passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count > 0 else { return false }

        guard retypePasswordTextField.text != nil else { return false }
        guard retypePasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count > 0 else { return false }
        
        guard passwordTextField.text == retypePasswordTextField.text else { return false}
        
        return true
    }
    
    private func gatherUserInput() {
        self.vault = Vault(withName: self.vaultNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        self.password = self.passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
