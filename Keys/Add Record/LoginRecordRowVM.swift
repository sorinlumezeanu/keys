//
//  LoginRecordRowVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/22/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class LoginRecordRowVM: BaseRecordRowVM, RecordRowVM {
    
    var cellIdentifier: String {
        return LoginRecordRowVM.LoginCellId
    }
    
    var rowHeight: CGFloat {
        return LoginRecordRowVM.StandardRowHeight
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