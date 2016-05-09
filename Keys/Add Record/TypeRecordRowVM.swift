//
//  TypeRecordRowVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class TypeRecordRowVM: BaseRecordRowVM, RecordRowVM {
    
    private var recordType: Secret.Type5!
    
    convenience init(recordVM: RecordVM, recordType: Secret.Type5) {
        self.init(recordVM: recordVM)
        
        self.recordType = recordType
    }
    
    var cellIdentifier: String {
        return TypeRecordRowVM.TypeCellId
    }
    
    var rowHeight: CGFloat {
        return TypeRecordRowVM.StandardRowHeight
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)! as UITableViewCell
        
        cell.detailTextLabel?.text = self.recordType.rawValue
        
        return cell
    }
}