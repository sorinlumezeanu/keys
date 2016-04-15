//
//  SecretField.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class SecretField: NSObject, NSCoding {
    
    enum Type2: String {
        case System = "Target System"
        case Url = "Url"
        case Email = "Email"
        case Username = "Username"
        case Password = "Password"
        case CCNumber = "Credit Card No."
        case PhoneNumber = "Phone No."
        case NoteTitle = "Note Title"
        case NoteParagraph = "Note Paragraph"
    }
    
    var type: Type2
    var label: String
    var value: String?
    var image: Image?
    var isMandatory: Bool
    
    init(withType type: Type2, mandatory: Bool)
    {
        self.type = type
        self.label = type.rawValue
        self.isMandatory = mandatory
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? String else { return nil }
        guard let type = Type2(rawValue: typeRawValue) else { return nil }
        guard let isMandatory = decoder.decodeObjectForKey("isMandatory") as? Bool else { return nil }
        
        self.init(withType: type, mandatory: isMandatory)
        
        if let label = decoder.decodeObjectForKey("label") as? String {
            self.label = label
        } else {
            self.label = self.type.rawValue
        }
        if let value = decoder.decodeObjectForKey("value") as? String {
            self.value = value
        }
        if let image = decoder.decodeObjectForKey("image") as? Image {
            self.image = image
        }
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.type.rawValue, forKey: "type")
        coder.encodeObject(self.isMandatory, forKey: "isMandatory")
        coder.encodeObject(self.label, forKey: "label")
        if self.value != nil {
            coder.encodeObject(self.value, forKey: "value")
        }
        if self.image != nil {
            coder.encodeObject(self.image, forKey: "image")
        }
    }
}