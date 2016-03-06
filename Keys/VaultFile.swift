//
//  VaultFile.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/4/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class VaultFile {
    var fileName: String = ""
    var fileData: NSData?
    
    func iterateDocuments() {
        let fileManager = NSFileManager.defaultManager()
        let urlsForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        if urlsForDocumentsDirectory.count > 0 {
            let url = urlsForDocumentsDirectory[0]
            print("path=\(url.path)")
        }
    }
}