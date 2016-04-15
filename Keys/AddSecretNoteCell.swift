//
//  AddSecretFieldNoteCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/25/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

protocol AddSecretNoteCellDelegate {
    func onKeyboardReturnPressed(sender: AddSecretNoteCell)
    func receiveValueText(text: String?, sender: AddSecretNoteCell)
}

protocol AddSecretNoteCellDataSource {
    func getValueText() -> String?
}

class AddSecretNoteCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var noteTextView: UITextView!
    
    private var delegate: AddSecretNoteCellDelegate!
    private var dataSource: AddSecretNoteCellDataSource!
    
    func setup(delegate delegate: AddSecretNoteCellDelegate, dataSource: AddSecretNoteCellDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        
        self.noteTextView.text = self.dataSource.getValueText()
        self.noteTextView.delegate = self
    }
    
    func beginUserInput() {
        self.noteTextView.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        self.delegate.receiveValueText(self.getValue(), sender: self)
    }
    
    
    // MARK: - Validation
    
    private func getValue() -> String? {
        return self.noteTextView.text
    }
}
