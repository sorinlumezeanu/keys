//
//  File.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Repository
{
    private(set) static var vaultFiles = [VaultFile]()
    
    private static var fileManager = NSFileManager.defaultManager()
    private static var urlForDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    class func countUnlockedVaultFiles() -> Int {
        var count = 0
        for vaultFile in vaultFiles {
            if !vaultFile.isLocked {
                count += 1
            }
        }
        return count
    }
    
    class func loadVaultFiles()
    {
        //print (urlForDocumentsDirectory.path)
        
        vaultFiles = [VaultFile]()
        
        if let contentsOfDocumentsDirectory = Repository.readContentsOfDocumentsDirectory() {
            for fileUrl in contentsOfDocumentsDirectory {
                let vaultFile = VaultFile(withFileUrl: fileUrl)
                if vaultFile.load() {
                    vaultFiles.append(vaultFile)
                }
            }
        }
    }
    
    class func addVaultFile(vaultFile: VaultFile) {
        vaultFiles.append(vaultFile)
    }
    
    class func saveVaultFiles()
    {
        for vaultFile in vaultFiles {
            vaultFile.save()
        }
    }
    
    private class func readContentsOfDocumentsDirectory() -> [NSURL]? {
        do {
            let contentsOfDocumentsDirectory = try fileManager.contentsOfDirectoryAtURL(urlForDocumentsDirectory, includingPropertiesForKeys: nil, options: [.SkipsHiddenFiles, .SkipsPackageDescendants, .SkipsSubdirectoryDescendants])
            return contentsOfDocumentsDirectory
        }
        catch let error as NSError {
            print ("reading files error: \(error.description)")
        }
        
        return nil
    }
}