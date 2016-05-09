//
//  SecretFieldImage.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/19/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation
import UIKit

class Image: NSObject, NSCoding {
    
    enum Type3: Int {
        case Bundled
        case Extern
    }
    
    var type: Type3
    var url: String
    
    private(set) lazy var image: UIImage? = {
            switch (self.type) {
            case .Bundled:
                return UIImage(named: self.url)
            default:
                return nil
            }
    }()
    
    init(type: Type3, url: String) {
        self.type = type
        self.url = url
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let typeRawValue = decoder.decodeObjectForKey("type") as? Int else { return nil }
        guard let type = Type3(rawValue: typeRawValue) else { return nil }
        guard let url = decoder.decodeObjectForKey("url") as? String else { return nil }
        
        self.init(type: type, url: url)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.type.rawValue, forKey: "type")
        coder.encodeObject(self.url, forKey: "url")
    }
}