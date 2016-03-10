//
//  NSData+Extension.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/8/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

extension NSData {
    
    func safeSubdataWithRange(range: NSRange) -> NSData? {
        guard range.location >= 0 && range.location < self.length
            else { return nil }
        guard range.length > 0 && range.location + range.length <= self.length
            else { return nil }
        return self.subdataWithRange(range)
    }
    
}