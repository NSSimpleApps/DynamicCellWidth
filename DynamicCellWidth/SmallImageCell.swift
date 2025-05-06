//
//  ImageCell.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 29.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

private let kImageSize = CGSize(width: 24, height: 24)

class SmallImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        
        self.imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.widthAnchor.constraint(equalToConstant: kImageSize.width).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: kImageSize.height).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SmallImageCell: @preconcurrency SizeLayout {
    typealias SizeContext = UIImage
    
    static func size(using context: SizeContext,
                     boundingSize: CGSize) -> CGSize {
        
        return kImageSize
    }
}

protocol ImageCellConfigurator {
    var image: UIImage? { get }
}

extension SmallImageCell: @preconcurrency CellConfiguration {
    typealias Configurator = ImageCellConfigurator
    
    func configure(with configurator: Configurator) {
        self.imageView.image = configurator.image
    }
}

