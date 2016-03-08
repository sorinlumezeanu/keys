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
    
    var fileUrl: NSURL!     // make readonly
    var vault: Vault!       // make readonly
    var salt: NSData!       // make readonly
    var iv: NSData!         // make readonly
    
    init(withVault vault: Vault)
    {
        self.vault = vault
        updateFileUrl()
    }
    
    init?(withFileUrl fileUrl: NSURL)
    {
        self.fileUrl = fileUrl
        if load() == false {
            return nil
        }
    }
    
    func load() -> Bool
    {
        guard let fileData = NSData(contentsOfURL: fileUrl) else {
            print("Unable to read content of file: \(fileUrl.path)")
            return false
        }
        
        return unpackFileData(fileData)
    }
    
    func save() -> Bool
    {
        let fileData = packFileData()
        
        do {
            try fileData.writeToURL(fileUrl, options: [.DataWritingAtomic, .DataWritingFileProtectionComplete])
        }
        catch let error as NSError {
            print ("saving file [\(fileUrl.path)] error: \(error.description)")
            return false
        }
        
        return true
    }
    
    private func unpackFileData(fileData: NSData) -> Bool
    {
        let aesCryptor = AESCryptor.createWithAlgorithm(AES128)
        let saltSize = Int(aesCryptor.saltSize)
        let blockSize = Int(aesCryptor.blockSize)
        
        salt = fileData.subdataWithRange(NSRange(location: 0, length: saltSize))
        iv = fileData.subdataWithRange(NSRange(location: saltSize, length: blockSize))
        let encryptedVaultBytes = fileData.subdataWithRange(NSRange(location: saltSize + blockSize,
            length: fileData.length - (saltSize + blockSize)))
        
        let key = aesCryptor.generateKeyFromPassphrase(passphrase, andSalt: salt!)
        let cleartextVaultBytes = aesCryptor.decrypt(encryptedVaultBytes, withKey: key, initializationVector: iv)

        self.vault = NSKeyedUnarchiver.unarchiveObjectWithData(cleartextVaultBytes!) as? Vault
        if self.vault == nil {
            print("failed to read vault file: " + fileUrl.path!)
        }
        
        return (self.vault != nil)
    }
    
    private func packFileData() -> NSData
    {
        let fileData = NSMutableData()
        
        let aesCryptor = AESCryptor.createWithAlgorithm(AES128)
        if salt == nil || iv == nil
        {
            salt = aesCryptor.generateSalt()
            iv = aesCryptor.generateInitializationVector()
            
        }
        
        let vaultData = NSKeyedArchiver.archivedDataWithRootObject(vault!)
        let encryptionKey = aesCryptor.generateKeyFromPassphrase(passphrase, andSalt: salt!)
        let encryptedVaultData = aesCryptor.encrypt(vaultData, withKey: encryptionKey, initializationVector: iv!)
        
        fileData.appendData(salt!)
        fileData.appendData(iv!)
        fileData.appendData(encryptedVaultData)
        
        return fileData
    }
    
    private func updateFileUrl()
    {
        fileUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent(vault.name + ".vf")
    }
}