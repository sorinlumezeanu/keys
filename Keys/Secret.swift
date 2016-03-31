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
    
    var uuid: String
    var type: Type5
    var name: String
    var fields: [SecretField]
    
    init(withType type: Type5, name: String, uuid: String? = nil)
    {
        self.uuid = uuid ?? NSUUID().UUIDString
        self.type = type
        self.name = name
        self.fields = [SecretField]()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let uuid = decoder.decodeObjectForKey("uuid") as? String else { return nil }
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? String else { return nil }
        guard let type = Type5(rawValue: typeRawValue) else { return nil }
        guard let name = decoder.decodeObjectForKey("name") as? String else { return nil }
        
        self.init(withType: type, name: name, uuid: uuid)
        
        if let fields = decoder.decodeObjectForKey("fields") as? [SecretField] {
            self.fields += fields
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(uuid, forKey: "uuid")
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
            secret.fields.append(SecretField(withType: .System))
            secret.fields.append(SecretField(withType: .Url))
            secret.fields.append(SecretField(withType: .Username))
            secret.fields.append(SecretField(withType: .Password))
            return secret
            
        case .Note:
            secret.fields.append(SecretField(withType: .NoteTitle))
            secret.fields.append(SecretField(withType: .NoteParagraph))
            return secret
            
        default:
            secret.fields.append(SecretField(withType: .System))
            secret.fields.append(SecretField(withType: .NoteParagraph))
        }
        
        return secret
    }
}