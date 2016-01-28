//
//  Label.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/29/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import Foundation

class Label {
    var blockLetter: String = ""
    var className: String = ""
    var classTimes: String = ""
    
    init(bL: String, cN: String, cT: String) {
        blockLetter = bL
        className = cN
        classTimes = cT
    }
}