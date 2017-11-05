//
//  UICollectionView+Helpers.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 28.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit


extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withCellClass cellClass: T.Type, for indexPath: IndexPath) -> T {
        
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as! T
    }
}
