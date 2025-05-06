//
//  Protocols.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 29.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

@preconcurrency
protocol SizeLayout {
    associatedtype SizeContext
    
    static func size(using context: SizeContext,
                     boundingSize: CGSize) -> CGSize
}

@preconcurrency
protocol CellConfiguration: AnyObject {
    associatedtype Configurator
    
    func configure(with configurator: Configurator)
}
