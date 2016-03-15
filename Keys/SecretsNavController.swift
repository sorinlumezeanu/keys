//
//  SecretsNavController.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretsNavController: UINavigationController {

    private struct Constants {
        static let ShowZeroVaultsSegueId = "ShowZeroVaultsVC"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case Constants.ShowZeroVaultsSegueId:
            break
        default:
            break
        }
    }
}
