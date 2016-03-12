//
//  MainTabBarController.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    func setup() {
        (viewControllers![0] as! SecretsNavController).setup()
    }

}
