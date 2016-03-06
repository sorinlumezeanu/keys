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
    static let sharedInstance = Repository()
    
    private static var vaults = [Vault]()
    
    private init() {
        
        let savedVaults = Repository.readVaultFiles()
        if savedVaults != nil && savedVaults?.count > 0 {
            print("read \(savedVaults!.count) files")
            Repository.vaults += savedVaults!
        }
        else
        {
            let secret1 = Secret(withType: .Login, name: "facebook")
            let secret2 = Secret(withType: .Login, name: "google")
            let secret3 = Secret(withType: .Login, name: "apple")
            
            Repository.vaults.append(Vault(withName: "Sorin", secrets: [secret1, secret2]))
            Repository.vaults.append(Vault(withName: "Costina", secrets: [secret3]))
            
            for vault in Repository.vaults {
                Repository.saveVaultFile(vault)
            }
        }
    }
    
    func getVaults() -> [Vault] {
        return Repository.vaults
    }
    
    class func saveVaultFile(file: Vault) {
        let fileBytes = NSKeyedArchiver.archivedDataWithRootObject(file)
        let fileManager = NSFileManager.defaultManager()
        let urlForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fileUrl = urlForDocumentsDirectory.URLByAppendingPathComponent(file.name + ".vf")
        fileBytes.writeToURL(fileUrl, atomically: true)
    }
    
    class func readVaultFiles() -> [Vault]? {
        let fileManager = NSFileManager.defaultManager()
        let urlForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            let fileUrls = try fileManager.contentsOfDirectoryAtURL(urlForDocumentsDirectory, includingPropertiesForKeys: nil, options: [.SkipsHiddenFiles, .SkipsPackageDescendants, .SkipsSubdirectoryDescendants])
            var vaults = [Vault]()
            for fileUrl in fileUrls {
                let fileBytes = NSData(contentsOfURL: fileUrl)
                let vault = NSKeyedUnarchiver.unarchiveObjectWithData(fileBytes!) as! Vault
                vaults.append(vault)
            }
            return vaults
        }
        catch let error as NSError {
            error.description
        }
        
        return nil
    }
}