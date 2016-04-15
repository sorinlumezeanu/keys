//
//  RowDescriptor.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/31/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

protocol RowDescriptor: class {
    var cellIdentifier: String { get }
    var rowHeight: CGFloat { get }
    var canEdit: Bool { get }
    var editingStyle: UITableViewCellEditingStyle { get }
    var canMove: Bool { get }
    
    var recordDescriptor: RecordDescriptor { get }
    init(recordDescriptor: RecordDescriptor)
    
    func prepareCell(forTableView tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
}

extension RowDescriptor {
    static var StandardRowHeight: CGFloat { return CGFloat(44) }
    static var DoubleRowHeight: CGFloat { return CGFloat(88) }    
}
