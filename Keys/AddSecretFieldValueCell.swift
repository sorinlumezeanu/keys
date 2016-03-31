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
    @IBOutlet weak var errorImageView: UIImageView!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func setup(delegate delegate: AddSecretFieldCellDelegate, dataSource: AddSecretFieldCellDataSource) {
        super.setup(delegate: delegate, dataSource: dataSource)
        
        self.valueTextField.text = self.dataSource.getDisplayValue()
        self.valueTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: self.valueTextField
        )
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
    
    func textFieldTextChanged(sender : AnyObject) {
        if self.errorImageView != nil {
            self.errorImageView.hidden = !self.errorImageView.hidden
        }
        
        if case let value = self.getValue() where self.validate(value: value) {
            self.dataSource.receiveValue(value)
        }
        else {
            self.dataSource.receiveValue(nil)
        }
    }
    
    // MARK: - Validation
    
    private func getValue() -> String? {
        return self.valueTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    private func validate(value value: String?) -> Bool {
        guard value?.characters.count > 0 else { return false }
        return true
    }
}
