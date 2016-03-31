//
//  AddSecretVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/19/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddSecretVC: UITableViewController, UIPopoverPresentationControllerDelegate, AddSecretFieldCellDelegate {
    
    private struct Constants {
        static let ShowMenuSecretTypeSegueId = "ShowMenuSecretType"
        static let SaveAddSecretSegueId = "SaveAddSecretSegueId"
    }
    
    var secret: Secret?
    
    private var recordDescriptors: [Secret.Type5: RecordDescriptor] = [:]
    private var activeRecordDescriptor: RecordDescriptor!
    
    private weak var menuAnchor: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let secrets: [Secret] = [
            Secret.createWithType(.Login, name: "not used"),
            Secret.createWithType(.Note, name: "not used"),
            Secret.createWithType(.Other, name: "not used")]
        
        let recordDescriptors = secrets.map { RecordDescriptor(viewController: self, secret: $0) }
        for recordDescriptor in recordDescriptors {
            self.recordDescriptors[recordDescriptor.secret.type] = recordDescriptor
        }
        
        self.activeRecordDescriptor = self.recordDescriptors[.Login]
    }
    
    // MARK: - Navigation
    
    @IBAction func dismissMenu(segue: UIStoryboardSegue) {
        guard let menuVC = segue.sourceViewController as? MenuVC else { return }
        guard let selectedOption = menuVC.selectedOption else { return }
        guard let changeToSecretType = Secret.Type5(rawValue: selectedOption) else { return }
        
        if self.activeRecordDescriptor.secret.type != changeToSecretType {
            self.activeRecordDescriptor = self.recordDescriptors[changeToSecretType]
            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: 1)), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case Constants.SaveAddSecretSegueId:
            return false
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case Constants.ShowMenuSecretTypeSegueId:
            let menuVC = segue.destinationViewController as! MenuVC
            menuVC.options = Secret.Type5.allValues.map { $0.rawValue }
            menuVC.modalPresentationStyle = .Popover
            menuVC.popoverPresentationController?.delegate = self
            menuVC.popoverPresentationController?.sourceRect = self.menuAnchor!.frame
            
        case Constants.SaveAddSecretSegueId:
            self.secret = self.activeRecordDescriptor.secret
            
        default:
            break
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRecordDescriptor.rowDescriptors.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return activeRecordDescriptor[indexPath]?.rowHeight ?? CGFloat(0)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowDescriptor = self.activeRecordDescriptor[indexPath]!
        let cell = tableView.dequeueReusableCellWithIdentifier(rowDescriptor.cellIdentifier, forIndexPath: indexPath) as! AddSecretFieldBaseCell
        
        if rowDescriptor.type == .RecordTypeSelection {
            self.menuAnchor = cell.textLabel
        }
        
        cell.setup(delegate: self, dataSource: rowDescriptor)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let rowDescriptor = self.activeRecordDescriptor[indexPath] else { return }
        
        if rowDescriptor.type == .RecordTypeSelection {
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier(Constants.ShowMenuSecretTypeSegueId, sender: nil)
            })
        }
        else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddSecretFieldBaseCell
            cell.didSelectCell()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.activeRecordDescriptor[indexPath]?.canEdit ?? false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return self.activeRecordDescriptor[indexPath]?.editingStyle ?? .None
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.activeRecordDescriptor[indexPath]?.canMove ?? false
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    // MARK: - AddSecretFieldCellDelegate
    
    func onKeyboardReturnPressed(cell: AddSecretFieldBaseCell) {
        guard let rowIndexPath = self.tableView.indexPathForCell(cell) else { return }
        self.tableView.deselectRowAtIndexPath(rowIndexPath, animated: true)
        
        let nextRowIndexPath = NSIndexPath(forRow: rowIndexPath.row + 1, inSection: 0)
        guard let nextRowDescriptor = self.activeRecordDescriptor[nextRowIndexPath] else { return }
        if nextRowDescriptor.type == .Field {
            guard let nextCell = self.tableView.cellForRowAtIndexPath(nextRowIndexPath) else { return }
            (nextCell as? AddSecretFieldValueCell)?.valueTextField.becomeFirstResponder()
        } else {
            (cell as? AddSecretFieldValueCell)?.valueTextField.resignFirstResponder()
        }
    }
    
    
    // MARK: - RecordDescriptor
    
    class RecordDescriptor {
        unowned let viewController: AddSecretVC
        var secret: Secret
        var rowDescriptors: [RowDescriptor]
        
        init(viewController: AddSecretVC, secret: Secret) {
            self.viewController = viewController
            self.secret = secret
            self.rowDescriptors = [RowDescriptor]()
            self.rowDescriptors += [RowDescriptor(type: .RecordTypeSelection, recordDescriptor: self)]
            self.rowDescriptors += secret.fields.map { RowDescriptor(recordDescriptor: self, field: $0) }
            self.rowDescriptors += [RowDescriptor(type: .AddField, recordDescriptor: self)]
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
    }
    
    // MARK: - RowDescriptor
    
    class RowDescriptor: AddSecretFieldCellDataSource {
        
        enum Type7 {
            case Field
            case RecordTypeSelection
            case AddField
        }
        
        private struct Constants {
            static let TypeFieldCellIdentifier = "addSecretTypeFieldCell"
            static let SystemFieldCellIdentifier = "addSecretSystemFieldCell"
            static let UrlFieldCellIdentifier = "addSecretUrlFieldCell"
            static let AccountFieldCellIdentifier = "addSecretAccountFieldCell"
            static let PasswordFieldCellIdentifier = "addSecretPasswordFieldCell"
            static let InfoParagraphFieldCellIdentifier = "addSecretInfoParagraphFieldCell"
            static let GenericFieldCellIdentifier = "addSecretGenericFieldCell"
            static let AddFieldCellIdentifier = "addSecretAddFieldCell"
            
            static let StandardRowHeight = CGFloat(44)
            static let DoubleRowHeight = CGFloat(88)
        }
        
        let type: Type7
        unowned let recordDescriptor: RecordDescriptor
        let field: SecretField?
        
        init(type: Type7, recordDescriptor: RecordDescriptor, field: SecretField? = nil) {
            self.type = type
            self.recordDescriptor = recordDescriptor
            self.field = field
        }

        convenience init(recordDescriptor: RecordDescriptor, field: SecretField) {
            self.init(type: .Field, recordDescriptor: recordDescriptor, field: field)
        }
        
        var cellIdentifier: String {
            switch self.type {
            case .RecordTypeSelection:
                return Constants.TypeFieldCellIdentifier
            case .AddField:
                return Constants.AddFieldCellIdentifier
            case .Field:
                switch self.field!.type {
                case .System:           return Constants.SystemFieldCellIdentifier
                case .Url:              return Constants.UrlFieldCellIdentifier
                case .Email:            return Constants.AccountFieldCellIdentifier
                case .Username:         return Constants.AccountFieldCellIdentifier
                case .Password:         return Constants.PasswordFieldCellIdentifier
                case .NoteParagraph:    return Constants.InfoParagraphFieldCellIdentifier
                case .NoteTitle:        return Constants.GenericFieldCellIdentifier
                case .CCNumber:         return Constants.GenericFieldCellIdentifier
                case .PhoneNumber:      return Constants.GenericFieldCellIdentifier
                }
            }
        }
        
        var rowHeight: CGFloat {
            if self.type == .Field && self.field!.type == SecretField.Type2.NoteParagraph {
                return Constants.DoubleRowHeight
            } else {
                return Constants.StandardRowHeight
            }
        }
        
        var canEdit: Bool {
            switch self.type {
            case .RecordTypeSelection:
                return false
            case .AddField:
                return false
            case .Field:
                switch self.field!.type {
                case .System:           return false
                case .Url:              return true
                case .Email:            return true
                case .Username:         return true
                case .Password:         return true
                case .NoteParagraph:    return true
                case .NoteTitle:        return true
                case .CCNumber:         return true
                case .PhoneNumber:      return true
                }
            }
        }
        
        var editingStyle: UITableViewCellEditingStyle {
            return self.canEdit ? .Delete : .None
        }
        
        var canMove: Bool {
            return self.canEdit
        }
        
        // MARK: - AddSecretFieldCellDataSource
        
        func getDisplayLabel() -> String {
            switch self.type {
            case .RecordTypeSelection:
                return self.recordDescriptor.secret.type.rawValue
            case .AddField:
                return "n/a"
            case .Field:
                return self.field!.label ?? self.field!.type.rawValue
            }
        }
        
        func getDisplayValue() -> String? {
            switch self.type {
            case .RecordTypeSelection:
                return nil
            case .AddField:
                return nil
            case .Field:
                return self.field!.value ?? nil
            }
        }
        
        func receiveValue(value: String?) {
            switch self.type {
            case .RecordTypeSelection:
                break
            case .AddField:
                break
            case .Field:
                print("received value: \(value)")
                return self.field!.value = value
            }
        }
    }
}
