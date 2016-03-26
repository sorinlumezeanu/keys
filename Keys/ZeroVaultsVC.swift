//
//  ZeroVaultsVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/9/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class ZeroVaultsVC: UIViewController {
    
    struct Constants {
        static let AddVaultSegueId = "AddVault"
    }
    
    @IBAction func cancelAddVault(segue: UIStoryboardSegue) {
        print("cancelAddVault")
    }
    
//    @IBAction func saveAddVault(segue: UIStoryboardSegue) {
//        let addVaultVC = segue.sourceViewController as! AddVaultTVC
//        SecurityContext.sharedInstance.setPassphraseForVault(addVaultVC.vault, passphrase: addVaultVC.password)
//        Repository.addVaultFile(VaultFile(withVault: addVaultVC.vault))
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        default:
            break;
        }
    }

}
