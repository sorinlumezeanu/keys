//
//  SystemVM.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/23/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import UIKit

struct SystemVM {
    var photo: Image?
    var displayText: String?
    
    static var defaultImage: UIImage = {
        return UIImage(named: "defaultChoosePhoto")!
    }()
    
    static let defaultDisplayText = "Target System"

    init(displayText: String? = nil, photo: Image? = nil) {
        self.displayText = displayText
        self.photo = photo
    }
}
