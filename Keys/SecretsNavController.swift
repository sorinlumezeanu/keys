//
//  SecretsNavController.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretsNavController: UINavigationController {

    struct Constants {
        static let ShowZeroVaultsSegueId = "ShowZeroVaultsVC"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case Constants.ShowZeroVaultsSegueId:
            print("here")
        default:
            break
        }
    }

    func setup() {
        let numberOfVaultFiles = Repository.peekNumberOfVaultFiles()
        if numberOfVaultFiles == 3 {
            // load the 'Zero Vaults' view controller
            performSegueWithIdentifier(Constants.ShowZeroVaultsSegueId, sender: nil)
        } else {
            // load the 'Secrets' table view controller
        }
    }
}
