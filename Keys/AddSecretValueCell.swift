//
//  AddSecretFieldTVCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/21/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

protocol AddSecretValueCellDelegate {
    func onKeyboardReturnPressed(sender: AddSecretValueCell)
    func receiveValueText(text: String?, sender: AddSecretValueCell)
}

protocol AddSecretValueCellDataSource {
    func getValueText() -> String?
    func getValuePlaceholderText() -> String?
    var shouldDisplayFieldImage: Bool { get }
}

class AddSecretValueCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var fieldImageView: UIImageView!
    
    private var delegate: AddSecretValueCellDelegate!
    private var dataSource: AddSecretValueCellDataSource!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setup(delegate delegate: AddSecretValueCellDelegate, dataSource: AddSecretValueCellDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        
        self.valueTextField.text = self.dataSource.getValueText()
        self.valueTextField.placeholder = self.dataSource.getValuePlaceholderText()
        self.valueTextField.delegate = self
        
        self.fieldImageView.hidden = !self.dataSource.shouldDisplayFieldImage
        self.errorImageView.hidden = true
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(AddSecretValueCell.textFieldTextChanged(_:)),
            name:UITextFieldTextDidChangeNotification,
            object: self.valueTextField
        )
    }
    
    func beginUserInput() {
        self.valueTextField.becomeFirstResponder()
    }
    
    func endUserInput() {
        self.updateErrorInfo()
    }
    
    func updateErrorInfo() {
        let value = self.getValue()
        if value == nil || !self.validate(value: value) {
            self.errorImageView.hidden = false
        }
        else {
            self.errorImageView.hidden = true
        }
    }
        
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.updateErrorInfo()
        delegate.onKeyboardReturnPressed(self)
        return true
    }
    
    func textFieldTextChanged(sender : AnyObject) {
        self.updateErrorInfo()
        if case let value = self.getValue() where self.validate(value: value) {
            self.delegate.receiveValueText(value, sender: self)
        } else {
            self.delegate.receiveValueText(nil, sender: self)
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
