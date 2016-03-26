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
    var position: Int
    var label = ""
    var value = ""
    var image: Image?
    
    init(withType type: Type2, position: Int)
    {
        self.type = type
        self.position = position
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? String else { return nil }
        guard let type = Type2(rawValue: typeRawValue) else { return nil }
        guard let position = decoder.decodeObjectForKey("position") as? Int else { return nil }
        
        self.init(withType: type, position: position)
        
        if let label = decoder.decodeObjectForKey("label") as? String {
            self.label = label
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
        coder.encodeObject(self.position, forKey: "position")
        coder.encodeObject(self.label, forKey: "label")
        coder.encodeObject(self.value, forKey: "value")
        if self.image != nil {
            coder.encodeObject(self.image, forKey: "image")
        }
    }
}