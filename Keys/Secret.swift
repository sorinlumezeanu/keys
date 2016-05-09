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
    var fields: [SecretField]
    
    init(type: Type5, uuid: String? = nil)
    {
        self.uuid = uuid ?? NSUUID().UUIDString
        self.type = type
        self.fields = [SecretField]()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let uuid = decoder.decodeObjectForKey("uuid") as? String else { return nil }
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? String else { return nil }
        guard let type = Type5(rawValue: typeRawValue) else { return nil }
        
        self.init(type: type, uuid: uuid)
        
        if let fields = decoder.decodeObjectForKey("fields") as? [SecretField] {
            self.fields += fields
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(uuid, forKey: "uuid")
        coder.encodeObject(type.rawValue, forKey: "type")
        coder.encodeObject(fields, forKey: "fields")
    }
    
    subscript(fieldType: SecretField.Type2) -> [SecretField]? {
        get {
            return self.fields.filter { $0.type == fieldType }
        }
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
    
    class func createWithType(type: Type5) -> Secret {
        let secret = Secret(type: type)

        switch (type) {
        case .Login:
            secret.fields.append(SecretField(type: .System, mandatory: true))
            secret.fields.append(SecretField(type: .LoginWithSocialAccount, mandatory: true))
            secret.fields.append(SecretField(type: .Username, mandatory: true))
            secret.fields.append(SecretField(type: .Password, mandatory: true))
            return secret
            
        case .Note:
            secret.fields.append(SecretField(type: .NoteTitle, mandatory: true))
            secret.fields.append(SecretField(type: .NoteParagraph, mandatory: false))
            return secret
            
        case .Other:
            break
        }
        
        return secret
    }
}