//
//  GetPassphraseVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/14/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class GetPassphraseVC: UIViewController, UITextFieldDelegate {
    
    private struct Constants {
        static let ShowMainScreenSegueId = "ShowMainScreen"
    }

    @IBOutlet weak var passphraseTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        passphraseTextField.delegate = self
    }

    @IBAction func unlock() {
        let passphrase = passphraseTextField.text!
        let vaultFiles = Repository.vaultFiles
        
        var shouldAdvanceToMainScreen = false
        for vaultFile in vaultFiles {
            if vaultFile.decryptWithPassphrase(passphrase) {
                shouldAdvanceToMainScreen = true
                SecurityContext.sharedInstance.setPassphraseForVault(vaultFile.vault, passphrase: passphrase)
            }
        }
        
        if shouldAdvanceToMainScreen {
            advanceToMainScreen()
        }
    }
    
    func advanceToMainScreen() {
        performSegueWithIdentifier(Constants.ShowMainScreenSegueId, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case Constants.ShowMainScreenSegueId:
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passphraseTextField {
            return true
        }
        
        return false
    }
}
