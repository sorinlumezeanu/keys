//
//  spanac.swift
//  Keys
//
//  Created by Sorin Lumezeanu on 4/14/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

import Foundation

class Spanac {
    var mutableProperty = 1
    let immutableStuff = 2
    
    lazy var calculatePrperty: Int = { 5 }()
    
    func doSomeShit() -> Bool {
        let myArray = [1, 2, 3, 4, 5, 6, 7]
        
        let x = myArray [2]
        switch x {
        case 1: // do some shit
            break
            
        case let xx where xx < 5:
            print(xx)
            break
            
        default:
            self.createColor(.None)
            break
        }
        
        return false
    }
    
    func createColor(someInt: Optionall) {
        
    }
}

enum Optionall {
    case None
    case Some(Int)
}