//
//  Vault.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/2/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Vault: NSObject, NSCoding {
    var uuid: String
    var name: String
    var secrets: [Secret]
    
    init(withName name: String, uuid:String? = nil, secrets: [Secret]? = nil)
    {
        self.uuid = uuid ?? NSUUID().UUIDString
        self.name = name
        self.secrets = secrets ?? [Secret]()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let uuid = decoder.decodeObjectForKey("uuid") as? String else { return nil }
        guard let name = decoder.decodeObjectForKey("name") as? String else { return nil }
        guard let secrets = decoder.decodeObjectForKey("secrets") as? [Secret] else { return nil }
        
        self.init(withName: name, uuid: uuid, secrets: secrets)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(uuid, forKey: "uuid")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(secrets, forKey: "secrets")
    }
    
    subscript(indexPath: NSIndexPath) -> Secret? {
        get {
            guard indexPath.section == 0 && indexPath.row < self.secrets.count else { return nil }
            return self.secrets[indexPath.row]
        }
    }
    
    // MARK: - Modify Actions
    
    private var backupSecrets: [Secret]?
    
    private func ensureBackup() {
        if self.backupSecrets == nil {
            self.backupSecrets = self.secrets
        }
    }
    
    func remove(secret secret: Secret) {
        self.ensureBackup()
        if let index = self.secrets.indexOf({ $0.uuid == secret.uuid }) {
            self.secrets.removeAtIndex(index)
        }
    }
    
    func append(secret secret: Secret) {
        self.ensureBackup()
        self.secrets.append(secret)
    }
    
    func move(secret secret: Secret, toIndex: Int) {
        guard let sourceIndex = self.secrets.indexOf({ $0.uuid == secret.uuid }) else { return }
        guard toIndex >= 0 && toIndex < self.secrets.count else { return }
        self.ensureBackup()        

        self.secrets.removeAtIndex(sourceIndex)
        self.secrets.insert(secret, atIndex: toIndex)
    }
    
    func discardChanges() {
        if self.backupSecrets != nil {
            self.secrets = self.backupSecrets!
        }
        self.backupSecrets = nil
    }
    
    func commitChanges() {
        self.backupSecrets = nil
    }
}