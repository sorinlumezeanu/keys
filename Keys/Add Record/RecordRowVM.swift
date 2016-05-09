//
//  RecordRowVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

protocol RecordRowVM: class {
    var cellIdentifier: String { get }
    var rowHeight: CGFloat { get }
    var canEdit: Bool { get }
    var editingStyle: UITableViewCellEditingStyle { get }
    var canMove: Bool { get }
    
    var recordVM: RecordVM { get }
    var field: SecretField! { get }
    
    init(recordVM: RecordVM)
    init(recordVM: RecordVM, field: SecretField)
    
    func prepareCell(indexPath indexPath: NSIndexPath) -> UITableViewCell
}

extension RecordRowVM {
    static var StandardRowHeight: CGFloat { return 44 }
    static var DoubleRowHeight: CGFloat { return 88 }
    
    static var TypeCellId: String { return "AddRecordTypeCell" }
    static var SystemCellId: String { return "AddRecordSystemCell" }
    static var LoginCellId: String { return "AddRecordLoginCell" }
    static var ValueCellId: String { return "AddRecordValueCell" }
    static var NoteCellId: String { return "AddRecordNoteCell" }
    static var AddFieldCellId: String { return "AddRecordAddFieldCell" }
    
    var tableView: UITableView { return self.recordVM.addRecordVC.tableView }
}

class BaseRecordRowVM {
    
    let recordVM: RecordVM
    var field: SecretField!
    
    required init(recordVM: RecordVM) {
        self.recordVM = recordVM
        self.field = nil
    }
    
    required init(recordVM: RecordVM, field: SecretField) {
        self.recordVM = recordVM
        self.field = field
    }
}