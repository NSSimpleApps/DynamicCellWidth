//
//  Number+Helpers.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 29.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import Foundation

extension SignedNumber {
    
    func validate(range: ClosedRange<Self>) -> Self {
        
        if self < range.lowerBound {
            
            return range.lowerBound
            
        } else if self > range.upperBound {
            
            return range.upperBound
            
        } else {
            
            return self
        }
    }
}
