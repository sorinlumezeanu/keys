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
    private static var vaultFiles = [VaultFile]()
    
    class func getVaults() -> [VaultFile] {
        return Repository.vaultFiles
    }
    
    class func loadVaultFiles()
    {
        Repository.vaultFiles = [VaultFile]()
        if let persistedVaultFiles = Repository.readVaultFiles() {
            Repository.vaultFiles += persistedVaultFiles
        }
        
        if Repository.vaultFiles.isEmpty {
            print("failed to read from disk, creating in-memory Vaultfiles")
            
            let secret1 = Secret(withType: .Login, name: "facebook")
            let secret2 = Secret(withType: .Login, name: "google")
            let secret3 = Secret(withType: .Login, name: "apple")
                        
            Repository.vaultFiles.append(VaultFile(withVault:Vault(withName: "Sorin", secrets: [secret1, secret2])))
            Repository.vaultFiles.append(VaultFile(withVault:Vault(withName: "Costina", secrets: [secret3])))
            saveVaultFiles()
        }
    }
    
    class func saveVaultFiles()
    {
        for vaultFile in Repository.vaultFiles {
            vaultFile.save()
        }
    }
    
    class func readVaultFiles() -> [VaultFile]? {
        let fileManager = NSFileManager.defaultManager()
        let urlForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
        
        do {
            let fileUrls = try fileManager.contentsOfDirectoryAtURL(urlForDocumentsDirectory, includingPropertiesForKeys: nil, options: [.SkipsHiddenFiles, .SkipsPackageDescendants, .SkipsSubdirectoryDescendants])
            
            var vaultFiles = [VaultFile]()
            for fileUrl in fileUrls {
                if let vaultFile = VaultFile(withFileUrl: fileUrl) {
                    vaultFiles.append(vaultFile)
                }
            }
            return vaultFiles
        }
        catch let error as NSError {
            print ("reading files error: \(error.description)")
        }
        
        return nil
    }
    
//    class func saveVault(vault: Vault) {        
//        let fileBytes = NSKeyedArchiver.archivedDataWithRootObject(vault)
//        let fileManager = NSFileManager.defaultManager()
//        let urlForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//        let fileUrl = urlForDocumentsDirectory.URLByAppendingPathComponent(vault.name + ".vf")
//        
//        //fileBytes.writeToURL(fileUrl, atomically: true)
//        do {
//            try fileBytes.writeToURL(fileUrl, options: [.DataWritingAtomic, .DataWritingFileProtectionComplete])
//        }
//        catch let error as NSError {
//            print ("saving file [\(vault.name)] error: \(error.description)")
//        }
//    }
}