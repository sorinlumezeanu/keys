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
    
    override func setup(delegate delegate: AddSecretFieldCellDelegate, dataSource: AddSecretFieldCellDataSource) {
        super.setup(delegate: delegate, dataSource: dataSource)
        
        self.valueLabel.text = self.dataSource.getDisplayLabel()
    }
}
