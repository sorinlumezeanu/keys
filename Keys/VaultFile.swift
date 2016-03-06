//
//  VaultFile.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/4/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class VaultFile {
    let passphrase = "Spanac777"
    
    
    var vault: Vault? = nil
    var salt: NSData? = nil
    var iv: NSData? = nil
    
    init(withVault vault: Vault)
    {
        self.vault = vault
        self.salt = nil
        self.iv = nil
        saveToDisk()
    }
    
    init?(withFileUrl fileUrl: NSURL)
    {
        if load(fileUrl) == false {
            return nil
        }
    }
    
    func load(fileUrl: NSURL) -> Bool
    {
        let fileBytes = NSData(contentsOfURL: fileUrl)
        
        salt = fileBytes?.subdataWithRange(NSRange(location: 0, length: 8))
        iv = fileBytes?.subdataWithRange(NSRange(location: 8, length: 16))
        let encryptedVaultBytes = fileBytes?.subdataWithRange(NSRange(location: 24, length: fileBytes!.length - 24))
        
        let securityServices = SecurityServices()
        let key = securityServices.generateAESKeyFromPassphrase(passphrase, andSalt: salt!)
        let cleartextVaultBytes = securityServices.decrypt(encryptedVaultBytes, withKey: key, initializationVector: iv)
        //let cleartextVaultBytes = encryptedVaultBytes
        
        print("load: \(fileUrl.pathComponents!.last!): salt=[\(salt?.description)] iv=[\(iv?.description)] datalength=\(cleartextVaultBytes?.length)")
        
        self.vault = NSKeyedUnarchiver.unarchiveObjectWithData(cleartextVaultBytes!) as? Vault
        
        if self.vault == nil {
            print("failed to read vault file: " + fileUrl.path!)
        }
        
        return (self.vault != nil)
    }
    
    func saveToDisk()
    {
        let fileManager = NSFileManager.defaultManager()
        let urlForDocumentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let vaultFileUrl = urlForDocumentsDirectory.URLByAppendingPathComponent(vault!.name + ".vf")
        
        let vaultData = NSKeyedArchiver.archivedDataWithRootObject(vault!)
        
        //print("---- save ----")
        //print(vaultData.description)
        
        let securityServices = SecurityServices()
        if salt == nil || iv == nil
        {
            salt = securityServices.generateSalt()
            iv = securityServices.generateAESInitializationVector()
            print("save: \(vault?.name): generated salt & iv")
            
        }
        
        print("save: \(vault?.name): salt=[\(salt?.description)] iv=[\(iv?.description)] datalength=\(vaultData.length)")
        
        let encryptionKey = securityServices.generateAESKeyFromPassphrase(passphrase, andSalt: salt!)
        let encryptedVaultData = securityServices.encrypt(vaultData, withKey: encryptionKey, initializationVector: iv!)
        //let encryptedVaultData = vaultData
        
        let fileData = NSMutableData()
        fileData.appendData(salt!)
        fileData.appendData(iv!)
        fileData.appendData(encryptedVaultData)
        
        do {
            try fileData.writeToURL(vaultFileUrl, options: [.DataWritingAtomic, .DataWritingFileProtectionComplete])
        }
        catch let error as NSError {
            print ("saving file [\(vaultFileUrl.path)] error: \(error.description)")
        }
    }
}