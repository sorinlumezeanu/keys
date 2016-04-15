//
//  ValueFieldRowDescriptor.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/31/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretFieldRowDescriptor: RowDescriptor, AddSecretValueCellDelegate, AddSecretValueCellDataSource, AddSecretNoteCellDelegate, AddSecretNoteCellDataSource {
    
    unowned let recordDescriptor: RecordDescriptor
    let field: SecretField!
    
    required convenience init(recordDescriptor: RecordDescriptor) {
        self.init(recordDescriptor: recordDescriptor, field: nil)
    }
    
    required init(recordDescriptor: RecordDescriptor, field: SecretField?) {
        self.recordDescriptor = recordDescriptor
        self.field = field
    }
    
    private struct Constants {
        static let ValueCellIdentifier = "addSecretValueCell"
        static let NoteCellIdentifier = "addSecretNoteCell"
    }
    
    var cellIdentifier: String {
        return self.field.type == .NoteParagraph ? Constants.NoteCellIdentifier : Constants.ValueCellIdentifier
    }
    
    var rowHeight: CGFloat {
        return self.field.type == .NoteParagraph ? SecretFieldRowDescriptor.DoubleRowHeight : SecretFieldRowDescriptor.StandardRowHeight
    }
    
    var canEdit: Bool {
        return true
    }
    
    var editingStyle: UITableViewCellEditingStyle {
        return .Delete
    }
    
    var canMove: Bool {
        return true
    }

    func prepareCell(forTableView tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)

        if self.field.type == .NoteParagraph {
            let noteCell = cell as! AddSecretNoteCell
            noteCell.setup(delegate: self, dataSource: self)
            return noteCell
        } else {
            let valueCell = cell as! AddSecretValueCell
            valueCell.setup(delegate: self, dataSource: self)
            return valueCell
        }
    }

    func receiveValueText(text: String?, sender: AddSecretNoteCell) {
        self.receiveValueText(text)
    }
    
    func receiveValueText(text: String?, sender: AddSecretValueCell) {
        self.receiveValueText(text)
    }
    
    private func receiveValueText(text: String?) {
        self.field.value = text
    }

    func onKeyboardReturnPressed(sender: AddSecretValueCell) {
        self.onKeyboardReturnPressed()
    }
    
    func onKeyboardReturnPressed(sender: AddSecretNoteCell) {
        self.onKeyboardReturnPressed()
    }
    
    private func onKeyboardReturnPressed() {
        if let nextRowDescriptor = self.recordDescriptor.getNextRowDescriptor(startingFrom: self) as? SecretFieldRowDescriptor {
            let nextRowIndexPath = self.recordDescriptor[nextRowDescriptor]!
            self.recordDescriptor.viewController.selectRow(indexPath: nextRowIndexPath)
        }
    }
    
    func getValueText() -> String? {
        return self.field.value
    }
    
    func getValuePlaceholderText() -> String? {
        switch self.field.type {
        case .System: return "the target system e.g. Facebook etc."
        case .Email: return "email"
        case .Url: return "url e.g. www.facebook.com etc."
        case .Username: return "username"
        case .PhoneNumber: return "phone no."
        case .CCNumber: return "credit card no."
        case .Password: return "password"
        case .NoteTitle: return "note title"
        case .NoteParagraph: return "note"
        }
    }
    
    var shouldDisplayFieldImage: Bool {
        return self.field.type == .System
    }
    
    func canSave() -> Bool {
        if !self.field.isMandatory {
            return true
        }
        return self.field.value != nil
    }
}