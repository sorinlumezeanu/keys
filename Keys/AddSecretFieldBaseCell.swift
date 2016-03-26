//
//  AddSecretFieldBaseCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/25/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

protocol AddSecretFieldCellDelegate: class {
    func onKeyboardReturnPressed(cell: AddSecretFieldBaseCell)
}

class AddSecretFieldBaseCell: UITableViewCell {
    
    private(set) var rowDescriptor: AddSecretVC.RowDescriptor!
    private(set) weak var delegate: AddSecretFieldCellDelegate!

    func setup(delegate delegate: AddSecretFieldCellDelegate, rowDescriptor: AddSecretVC.RowDescriptor) {
        self.delegate = delegate
        self.rowDescriptor = rowDescriptor
    }
    
    func didSelectCell() {
    }
}
