//
//  Vault.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Vault: NSObject, NSCoding {
    var name: String
    var secrets: [Secret]
    
    init(withName name: String, secrets: [Secret])
    {
        self.name = name
        self.secrets = secrets
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObjectForKey("name") as? String else { return nil }
        guard let secrets = decoder.decodeObjectForKey("secrets") as? [Secret] else { return nil }
        
        self.init(withName: name, secrets: secrets)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(secrets, forKey: "secrets")
    }
    
    override var description: String {
        return "\(name): (\(secrets.count))"
    }
    
    var summary: String {
        var summary = ""
        for secret in secrets {
            summary += secret.description + "\r\n"
        }
        return summary
    }
}