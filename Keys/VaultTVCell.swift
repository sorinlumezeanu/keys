//
//  SettingsTVCell.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 3/6/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

class VaultTVCell: UITableViewCell {

    var vaultFile: VaultFile!
    
    @IBOutlet weak var vaultName: UILabel!
    @IBOutlet weak var lockedStateImage: UIImageView!
    
    func setup(vaultFile: VaultFile) {
        self.vaultFile = vaultFile
        vaultName.text = vaultFile.name
        lockedStateImage.image = vaultFile.isLocked ? UIImage(named: "first") : UIImage(named: "second")
    }
}
