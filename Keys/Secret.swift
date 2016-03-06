//
//  Secret.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Secret : NSObject, NSCoding {
    
    enum Type : Int {
        case Login
        case Other
    }
    
    var type: Type
    var name: String
    //var fields: [SecretField]
    
    init(withType type: Type, name: String)
    {
        self.type = type
        self.name = String()
        //self.fields = [SecretField]()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? Int else { return nil }
        guard let type = Type(rawValue: typeRawValue) else { return nil }
        guard let name = decoder.decodeObjectForKey("name") as? String else { return nil }
        
        self.init(withType: type, name: name)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(type.rawValue, forKey: "type")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(description, forKey: "description")
    }
}