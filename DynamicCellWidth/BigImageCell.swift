//
//  BigImageCell.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 30.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

class BigImageCell: UICollectionViewCell {
    
    let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        
        self.imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BigImageCell: SizeLayout {
    
    typealias SizeContext = UIImage
    
    static func size(using context: SizeContext,
                     boundingSize: CGSize) -> CGSize {
        
        let factor = min(boundingSize.width, boundingSize.height) / max(context.size.width, context.size.height)
        
        return CGSize(width: factor * context.size.width,
                      height: factor * context.size.height)
    }
}

extension BigImageCell: CellConfiguration {
    
    typealias Configurator = ImageCellConfigurator
    
    func configure(with configurator: Configurator) {
        
        self.imageView.image = configurator.image
    }
}

