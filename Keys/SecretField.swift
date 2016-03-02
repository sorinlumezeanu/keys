//
//  SecretField.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class SecretField {
    
    enum Type {
        case Target
        case Username
        case Password
        case Other
    }
    
    var type: Type
    var label = String()
    var value = String()
    
    init(withType type: Type)
    {
        self.type = type
    }
}