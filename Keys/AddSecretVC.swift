//
//  AddSecretVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/19/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddSecretVC: UITableViewController, UIPopoverPresentationControllerDelegate {
    
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
    
    func selectRow(indexPath indexPath: NSIndexPath) {
        guard let rowDescriptor = self.activeRecordDescriptor[indexPath] else { return }
        
        switch rowDescriptor {
        case let typeRowDescriptor where typeRowDescriptor is TypeRowDescriptor:
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier(Constants.ShowMenuSecretTypeSegueId, sender: nil)
            })
            break
            
        case let secretFieldRowDescriptor where secretFieldRowDescriptor is SecretFieldRowDescriptor:
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                if let valueCell = cell as? AddSecretValueCell {
                    valueCell.beginUserInput()
                }
                if let noteCell = cell as? AddSecretNoteCell {
                    noteCell.beginUserInput()
                }
            }
            break
            
        case let addFieldRowDescriptor where addFieldRowDescriptor is AddFieldRowDescriptor:
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.addSecretFieldButtonTapped()
            break
        default:
            break
        }
    }
    
    @IBAction func addSecretFieldButtonTapped() {
        print("add secret field button tapped")
    }
    
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
            let canSave = self.activeRecordDescriptor.canSave()
            if canSave == false {
                self.tableView.visibleCells.forEach { visibleCell in
                    if let valueCell = visibleCell as? AddSecretValueCell {
                        valueCell.updateErrorInfo()
                    }
                }
            }
            return canSave
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
        let cell = rowDescriptor.prepareCell(forTableView: self.tableView, indexPath: indexPath)
        
        if rowDescriptor is TypeRowDescriptor {
            self.menuAnchor = cell.textLabel
        }
                
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectRow(indexPath: indexPath)
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


}
