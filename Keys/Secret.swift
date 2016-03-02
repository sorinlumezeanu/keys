//
//  Secret.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Secret {
    
    enum Type {
        case Login
        case Other
    }
    
    var type: Type
    var name: String
    var description: String?
    var fields: [SecretField]
    
    init(withType type: Type)
    {
        self.type = type
        self.name = String()
        self.fields = [SecretField]()
    }
}