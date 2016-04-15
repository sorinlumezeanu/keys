//
//  AddFieldRowDescriptor.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/31/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddFieldRowDescriptor: RowDescriptor {
    
    let recordDescriptor: RecordDescriptor
    
    required init(recordDescriptor: RecordDescriptor) {
        self.recordDescriptor = recordDescriptor
    }
    
    private struct Constants {
        static let CellIdentifier = "addSecretAddCell"
    }
    
    var cellIdentifier: String {
        return Constants.CellIdentifier
    }
    
    var rowHeight: CGFloat {
        return AddFieldRowDescriptor.StandardRowHeight
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
    
    func prepareCell(forTableView tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as UITableViewCell
                
        return cell
    }
}

