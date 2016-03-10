//
//  VaultFile.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/4/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class VaultFile {
    private(set) var fileUrl: NSURL!
    private(set) var vault: Vault!
    private(set) var salt: NSData!
    private(set) var iv: NSData!
    
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
        
        salt = fileData.safeSubdataWithRange(NSRange(location: 0, length: saltSize))
        guard salt != nil else {
            print("unable to unpack the salt")
            return false
        }
        
        iv = fileData.safeSubdataWithRange(NSRange(location: saltSize, length: blockSize))
        guard iv != nil else {
            print("unable to unpack the iv")
            return false
        }
        
        guard let encryptedVaultBytes = fileData.safeSubdataWithRange(NSRange(location: saltSize + blockSize,
            length: fileData.length - (saltSize + blockSize))) else {
                print("unable to unpack the encrypted vault bytes")
                return false
        }
        
        let key = aesCryptor.generateKeyFromPassphrase(SecurityContext.sharedInstance.mainPassphrase, andSalt: salt)
        let cleartextVaultBytes = aesCryptor.decrypt(encryptedVaultBytes, withKey: key, initializationVector: iv)

        vault = NSKeyedUnarchiver.unarchiveObjectWithData(cleartextVaultBytes!) as? Vault
        guard vault != nil else {
            print("failed to un-archive the Vault: " + fileUrl.path!)
            return false;
        }
        
        return true
    }
    
    private func packFileData() -> NSData
    {
        let fileData = NSMutableData()
        
        let aesCryptor = AESCryptor.createWithAlgorithm(AES128)
        if salt == nil || iv == nil {
            salt = aesCryptor.generateSalt()
            iv = aesCryptor.generateInitializationVector()
        }
        
        let vaultData = NSKeyedArchiver.archivedDataWithRootObject(vault!)
        let encryptionKey = aesCryptor.generateKeyFromPassphrase(SecurityContext.sharedInstance.getPassphraseForVault(vault), andSalt: salt!)
        let encryptedVaultData = aesCryptor.encrypt(vaultData, withKey: encryptionKey, initializationVector: iv!)
        
        fileData.appendData(salt)
        fileData.appendData(iv)
        fileData.appendData(encryptedVaultData)
        
        return fileData
    }
    
    private func updateFileUrl()
    {
        fileUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent(vault.name + ".vf")
    }
}