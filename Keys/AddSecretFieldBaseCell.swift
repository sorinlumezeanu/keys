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

protocol AddSecretFieldCellDataSource: class {
    func receiveValue(value: String?)
    func getDisplayLabel() -> String
    func getDisplayValue() -> String?
}

class AddSecretFieldBaseCell: UITableViewCell {
    
    private(set) weak var delegate: AddSecretFieldCellDelegate!
    private(set) weak var dataSource: AddSecretFieldCellDataSource!

    func setup(delegate delegate: AddSecretFieldCellDelegate, dataSource: AddSecretFieldCellDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func didSelectCell() {
    }
}
