//
//  VaultFile.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/4/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class VaultFile {
    
    var isLoaded: Bool {
        return fileUrl != nil && salt != nil && iv != nil && encryptedVaultData != nil
    }
    
    private(set) var fileUrl: NSURL!
    private(set) var vault: Vault!
    private(set) var salt: NSData!
    private(set) var iv: NSData!
    private(set) var encryptedVaultData: NSData!
    
    init(withVault vault: Vault)
    {
        self.vault = vault
    }
    
    init(withFileUrl fileUrl: NSURL)
    {
        self.fileUrl = fileUrl
    }
    
    func load() -> Bool
    {
        guard fileUrl != nil else { return false }
        
        if let fileData = NSData(contentsOfURL: fileUrl) {
            return unpack(fileData)
        }
        return false
    }
        
    func decryptWithPassphrase(passphrase: String) -> Bool
    {
        guard isLoaded else { return false }
        
        let aesCryptor = AESCryptor.createWithAlgorithm(AES128)
        let key = aesCryptor.generateKeyFromPassphrase(passphrase, andSalt: salt)
        let cleartextVaultBytes = aesCryptor.decrypt(encryptedVaultData, withKey: key, initializationVector: iv)

        vault = NSKeyedUnarchiver.unarchiveObjectWithData(cleartextVaultBytes!) as? Vault
        guard vault != nil else {
            print("failed to un-archive the Vault: " + fileUrl.path!)
            return false;
        }
        
        return true
    }
    
    func save() -> Bool
    {
        guard vault != nil else { return false }
        
        encryptWithPassphrase()
        updateFileUrl()
        
        let fileData = pack()
        do {
            try fileData.writeToURL(fileUrl, options: [.DataWritingAtomic, .DataWritingFileProtectionComplete])
        }
        catch let error as NSError {
            print ("saving file [\(fileUrl.path)] error: \(error.description)")
            return false
        }
        
        return true
    }
    
    private func unpack(fileData: NSData) -> Bool
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
        
        encryptedVaultData = fileData.safeSubdataWithRange(NSRange(location: saltSize + blockSize,
            length: fileData.length - (saltSize + blockSize)))
        guard encryptedVaultData != nil else {
                print("unable to unpack the encrypted vault bytes")
                return false
        }
        
        return true
    }
    
    private func encryptWithPassphrase()
    {
        let aesCryptor = AESCryptor.createWithAlgorithm(AES128)
        if salt == nil || iv == nil {
            salt = aesCryptor.generateSalt()
            iv = aesCryptor.generateInitializationVector()
        }
        
        let vaultData = NSKeyedArchiver.archivedDataWithRootObject(vault!)
        let encryptionKey = aesCryptor.generateKeyFromPassphrase(SecurityContext.sharedInstance.getPassphraseForVault(vault), andSalt: salt!)
        encryptedVaultData = aesCryptor.encrypt(vaultData, withKey: encryptionKey, initializationVector: iv!)
    }
    
    private func pack() -> NSData
    {
        let fileData = NSMutableData()
        
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