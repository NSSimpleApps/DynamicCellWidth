//
//  Cells.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 28.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

private let kImageSize = CGSize(width: 24, height: 24)
private let kTopInset: CGFloat = 0
private let kBottomInset: CGFloat = 4

class ImageLabelCell: UICollectionViewCell {
    
    let label = UILabel(frame: .zero)
    let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.widthAnchor.constraint(equalToConstant: kImageSize.width).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: kImageSize.height).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: kTopInset).isActive = true
        
        self.imageView.layer.borderColor = UIColor.green.cgColor
        self.imageView.layer.borderWidth = 0.5
        
        self.label.numberOfLines = 2
        
        self.label.layer.borderColor = UIColor.blue.cgColor
        self.label.layer.borderWidth = 0.5
        
        self.contentView.addSubview(self.label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: kBottomInset).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var font: UIFont {
        
        return UIFont.systemFont(ofSize: 10)
    }
    
    static var style: NSParagraphStyle {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingTail
        style.maximumLineHeight = 10
        style.minimumLineHeight = 10
        
        return style.copy() as! NSParagraphStyle
    }
    
    static var attributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: self.font,
                NSAttributedStringKey.paragraphStyle: self.style]
    }
}

extension ImageLabelCell: SizeLayout {
    
    typealias SizeContext = ImageLabelCellConfigurator
    
    static func size(using context: SizeContext,
                     boundingSize: CGSize) -> CGSize {
        
        if let text = context.text {
            
            let size = CGSize(width: boundingSize.width, height: boundingSize.height / 3)
            
            let boundingRect =
            (text as NSString).boundingRect(with: size,
                                            options: [.usesLineFragmentOrigin,
                                       .usesFontLeading],
                                            attributes: self.attributes,
                                            context: nil)
            
            return CGSize(width: max(kImageSize.width, boundingRect.width),
                          height: kImageSize.height + boundingRect.height + kTopInset + kBottomInset)
            
        } else {
            
            return CGSize(width: kImageSize.width, height: kImageSize.height + kTopInset + kBottomInset)
        }
    }
}

protocol ImageLabelCellConfigurator {
    
    var text: String? { get }
    var image: UIImage? { get }
}

extension ImageLabelCell: CellConfiguration {
    
    typealias Configurator = ImageLabelCellConfigurator
    
    func configure(with configurator: Configurator) {
        
        if let text = configurator.text {
            
            self.label.attributedText = NSAttributedString(string: text, attributes: ImageLabelCell.attributes)
            
        } else {
            
            self.label.attributedText = nil
        }
        
        self.imageView.image = configurator.image
    }
}

