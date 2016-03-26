//
//  Secret.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Secret : NSObject, NSCoding {
    
    enum Type5 : String {
        case Login = "Standard Login"
        case Note = "Note"
        case Other = "Other"
        
        static var allValues: [Type5] {
            return [.Login, .Note, .Other]
        }
    }
    
    var type: Type5
    var name: String
    var fields: [SecretField]
    
    init(withType type: Type5, name: String)
    {
        self.type = type
        self.name = name
        self.fields = [SecretField]()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? String else { return nil }
        guard let type = Type5(rawValue: typeRawValue) else { return nil }
        guard let name = decoder.decodeObjectForKey("name") as? String else { return nil }
        
        self.init(withType: type, name: name)
        
        if let fields = decoder.decodeObjectForKey("fields") as? [SecretField] {
            self.fields += fields
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(type.rawValue, forKey: "type")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(fields, forKey: "fields")
    }
    
    override var description: String {
        switch self.type {
        
        case .Login:
            return self.fields.filter({ $0.type == .System }).first?.value ?? "undefined system (login)"
        
        case .Note:
            return self.fields.filter({ $0.type == .NoteTitle }).first?.value ?? "undefined (note)"
            
        case .Other:
            return self.fields.filter({ $0.type == .System }).first?.value ?? "undefined (other)"
        }
    }
    
    class func createWithType(type: Type5, name: String) -> Secret {
        let secret = Secret(withType: type, name: name)

        switch (type) {
        case .Login:
            secret.fields.append(SecretField(withType: .System, position: 0))
            secret.fields.append(SecretField(withType: .Url, position: 1))
            secret.fields.append(SecretField(withType: .Username, position: 2))
            secret.fields.append(SecretField(withType: .Password, position: 3))
            return secret
            
        case .Note:
            secret.fields.append(SecretField(withType: .NoteTitle, position: 0))
            secret.fields.append(SecretField(withType: .NoteParagraph, position: 1))
            return secret
            
        default:
            secret.fields.append(SecretField(withType: .System, position: 0))
            secret.fields.append(SecretField(withType: .NoteParagraph, position: 1))
        }
        
        return secret
    }
}