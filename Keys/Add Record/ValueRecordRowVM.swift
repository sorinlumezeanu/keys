//
//  ValueRecordRowVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class ValueRecordRowVM: BaseRecordRowVM, RecordRowVM {
        
    var cellIdentifier: String {
        return ValueRecordRowVM.ValueCellId
    }
    
    var rowHeight: CGFloat {
        return ValueRecordRowVM.StandardRowHeight
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