//
//  RecordDescriptor.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/31/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class RecordDescriptor {
    unowned let viewController: AddSecretVC
    var secret: Secret
    var rowDescriptors: [RowDescriptor]
    
    init(viewController: AddSecretVC, secret: Secret) {
        self.viewController = viewController
        self.secret = secret
        self.rowDescriptors = [RowDescriptor]()
        self.rowDescriptors.append(TypeRowDescriptor(recordDescriptor: self))
        self.rowDescriptors += secret.fields.map { SecretFieldRowDescriptor(recordDescriptor: self, field: $0) } as [RowDescriptor]
        self.rowDescriptors.append(AddFieldRowDescriptor(recordDescriptor: self))
    }
    
    subscript(indexPath: NSIndexPath) -> RowDescriptor? {
        get {
            guard indexPath.section == 0 && indexPath.row < self.rowDescriptors.count else { return nil }
            return rowDescriptors[indexPath.row]
        }
    }
    
    subscript(rowDescriptor: RowDescriptor) -> NSIndexPath? {
        get {
            guard let index = self.rowDescriptors.indexOf( { $0 === rowDescriptor }) else { return nil }
            return NSIndexPath(forRow: index, inSection: 0)
        }
    }
    
    func getNextRowDescriptor(startingFrom rowDescriptor: RowDescriptor) -> RowDescriptor? {
        guard let index = self.rowDescriptors.indexOf( { $0 === rowDescriptor }) else { return nil }
        if index < self.rowDescriptors.count {
            return self.rowDescriptors[index + 1]
        }
        return nil
    }
    
    func canSave() -> Bool {
        let fieldRowDescriptors = self.rowDescriptors.filter( { $0 is SecretFieldRowDescriptor } )
        for row in fieldRowDescriptors {
            let fieldRowDescriptor = row as! SecretFieldRowDescriptor
            if !fieldRowDescriptor.canSave() {
                return false
            }
        }
        return true
    }
}