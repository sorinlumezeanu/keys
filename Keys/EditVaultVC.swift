//
//  EditVaultVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class EditVaultVC: UIViewController {

    enum Mode {
        case Add
        case Edit
    }
    
    struct Constants {
        static let CancelAddVaultSegueId = "CancelAddVault"
        static let SaveAddVaultSegueId = "SaveAddVault"
    }
    
    @IBOutlet weak var vaultName: UITextField!
    
    private (set) var mode: Mode = .Add
    private (set) var vault: Vault!
    
    func setup(mode: Mode, vault: Vault? = nil) {
        self.mode = mode
        self.vault = vault
    }
    
    // MARK: - Overrides
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if mode == .Edit {
            vaultName.text = vault.name
        }
        vaultName.becomeFirstResponder()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case Constants.CancelAddVaultSegueId:
            vault = nil
            
        case Constants.SaveAddVaultSegueId:
            print("prepare for segue - save")
            
        default:
            break;
        }
    }

}
