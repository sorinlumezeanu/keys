//
//  NoteRecordRowVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class NoteRecordRowVM: BaseRecordRowVM, RecordRowVM {
    
    var cellIdentifier: String {
        return NoteRecordRowVM.NoteCellId
    }
    
    var rowHeight: CGFloat {
        return NoteRecordRowVM.DoubleRowHeight
    }
    
    var canEdit: Bool {
        return false
    }
    
    var editingStyle: UITableViewCellEditingStyle {
        return .None
    }
    
    var canMove: Bool {
        return false
    }
    
    func prepareCell(indexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)
        return cell!
    }
}