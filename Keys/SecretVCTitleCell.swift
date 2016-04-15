//
//  SecretVCFieldCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/12/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class SecretVCTitleCell: UITableViewCell {

    var field: SecretField! {
        didSet {
            self.titleLabel.text = self.field.value
            if let actualImage = self.field.image?.image {
                self.fieldImage.image = actualImage
                self.fieldImage.hidden = false
            } else {
                self.fieldImage.hidden = true
            }
        }
    }

    @IBOutlet weak var fieldImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
