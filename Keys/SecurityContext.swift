//
//  SecurityContext.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/9/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class SecurityContext {
    static let sharedInstance = SecurityContext()
    
    private init() {
        passphrasesByVaultUuid = [String: String]()
    }
    
    private var passphrasesByVaultUuid: [String: String]!
    
    func getPassphraseForVault(vault: Vault) -> String? {
        if passphrasesByVaultUuid.keys.contains(vault.uuid) {
            return passphrasesByVaultUuid[vault.uuid]
        }
        return nil
    }
    
    func setPassphraseForVault(vault: Vault, passphrase: String) {
        passphrasesByVaultUuid[vault.uuid] = passphrase
    }    
}