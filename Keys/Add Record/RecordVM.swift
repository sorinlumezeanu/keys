//
//  RecordVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class RecordVM {
    
    unowned let addRecordVC: AddRecordVC
    let secret: Secret
    private var rows: [[RecordRowVM]]
    
    init(addRecordVC: AddRecordVC, secret: Secret) {
        self.addRecordVC = addRecordVC
        self.secret = secret
        self.rows = [[RecordRowVM]]()
        
        self.rows.append([TypeRecordRowVM(recordVM: self, recordType: self.secret.type)])
        self.rows.append([])
        for field in self.secret.fields {
            self.rows[1].appendContentsOf(self.createRowVMs(forField: field))
        }
        self.rows.append([AddFieldRecordRowVM(recordVM: self)])
    }
    
    subscript(indexPath: NSIndexPath) -> RecordRowVM? {
        get {
            return self.rows[indexPath.section][indexPath.row]
        }
    }
    
    var numberOfSections: Int {
        return self.rows.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.rows[section].count
    }
    
    func prepareCell(indexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self[indexPath]!.prepareCell(indexPath: indexPath)
    }
    
    func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        return self[indexPath]!.rowHeight
    }
    
    private func createRowVMs(forField field: SecretField) -> [RecordRowVM] {
        var rows = [RecordRowVM]()
        
        switch field.type {
        case .System:
            rows.append(SystemRecordRowVM(recordVM: self, field: field))
            
        case .LoginWithSocialAccount:
            rows.append(LoginRecordRowVM(recordVM: self, field: field))
            rows.append(ValueRecordRowVM(recordVM: self, field: field))
            
        case .Username, .Password, .CCNumber, .Url, .Email, .NoteTitle, .PhoneNumber:
            rows.append(ValueRecordRowVM(recordVM: self, field: field))
            
        case .NoteParagraph:
            rows.append(NoteRecordRowVM(recordVM: self))
        }
        
        return rows
    }
}