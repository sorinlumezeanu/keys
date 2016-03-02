//
//  Vault.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Vault {
    var name: String
    var secrets: [Secret]
    
    init(withName name: String)
    {
        self.name = name
        self.secrets = [Secret]()
    }
}