//
//  Number+Helpers.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 29.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import Foundation

func validate<T>(_ value: T, in range: ClosedRange<T>) -> T where T: SignedNumeric {
    
    if value < range.lowerBound {
        return range.lowerBound
        
    } else if value > range.upperBound {
        return range.upperBound
        
    } else {
        return value
    }
}
