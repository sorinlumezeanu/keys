//
//  SecretVC.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretVC: UITableViewController {

    private struct Constants {
        static let SecretVCTitleCellId = "SecretVCTitleCellId"
        static let SecretVCFieldsCellId = "SecretVCFieldCellId"
        static let SecretVCNotesCellId = "SecretVCNoteCellId"
        
        static let EstimatedTitleRowHeight = CGFloat(54)
        static let EstimatedFieldRowHeight = CGFloat(30)
        static let EstimatedNoteRowHeight = CGFloat(88)
    }
    
    var secret: Secret!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.secret.fields.count
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let field = self.secret.fields[indexPath.row]
        switch field.type {
        case .System:
            fallthrough
        case .NoteTitle:
            return Constants.EstimatedTitleRowHeight
        case .NoteParagraph:
            return Constants.EstimatedNoteRowHeight
        default:
            return Constants.EstimatedFieldRowHeight
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let field = self.secret.fields[indexPath.row]
        switch field.type {
        case .System:
            fallthrough
        case .NoteTitle:
            return self.prepareTitleCell(secretField: field)
        case .NoteParagraph:
            return self.prepareNoteCell(secretField: field)
        default:
            return self.prepareFieldCell(secretField: field)
        }
    }
    
    func prepareTitleCell(secretField field: SecretField) -> SecretVCTitleCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SecretVCTitleCellId) as! SecretVCTitleCell
        cell.field = field
        return cell
    }
    
    func prepareFieldCell(secretField field: SecretField) -> SecretVCFieldCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SecretVCFieldsCellId) as! SecretVCFieldCell
        cell.infoLabel.text = field.label.lowercaseString + ":"
        cell.valueLabel.text = field.value
        return cell
    }
    
    func prepareNoteCell(secretField field: SecretField) -> SecretVCNoteCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SecretVCNotesCellId) as! SecretVCNoteCell
        cell.noteTextView.text = field.value
        return cell
    }
}
