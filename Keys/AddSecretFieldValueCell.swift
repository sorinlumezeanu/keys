//
//  AddSecretFieldTVCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/21/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class AddSecretFieldValueCell: AddSecretFieldBaseCell, UITextFieldDelegate {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var systemImageView: UIImageView!
    
    override func setup(delegate delegate: AddSecretFieldCellDelegate, rowDescriptor: AddSecretVC.RowDescriptor) {
        super.setup(delegate: delegate, rowDescriptor: rowDescriptor)
        
        self.valueTextField.delegate = self
    }
    
    @IBAction func addPhotoButtonTapped() {
        print("add photo")
    }
    
    override func didSelectCell() {
        self.valueTextField.becomeFirstResponder()
    }

    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate.onKeyboardReturnPressed(self)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.rowDescriptor.field?.value = textField.text!        
    }
}
