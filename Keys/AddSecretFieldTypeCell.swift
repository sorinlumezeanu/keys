//
//  AddSecretFieldTypeCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/25/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddSecretFieldTypeCell: AddSecretFieldBaseCell {

    @IBOutlet weak var valueLabel: UILabel!

    override func setup(delegate delegate: AddSecretFieldCellDelegate, rowDescriptor: AddSecretVC.RowDescriptor) {
        super.setup(delegate: delegate, rowDescriptor: rowDescriptor)
        
        self.valueLabel.text = rowDescriptor.recordDescriptor.secret.type.rawValue
    }
}
