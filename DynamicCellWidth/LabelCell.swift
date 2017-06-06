//
//  LabelCell.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 29.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {
    
    let label = UILabel(frame: .zero)
    
    static let inset: CGFloat = 8
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        
        self.label.numberOfLines = 2
        self.label.layer.borderColor = UIColor.green.cgColor
        self.label.layer.borderWidth = 0.5
        
        self.contentView.addSubview(self.label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: LabelCell.inset).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -LabelCell.inset).isActive = true
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var font: UIFont {
        
        return UIFont.systemFont(ofSize: 15)
    }
    
    static var style: NSParagraphStyle {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingTail
        style.minimumLineHeight = 15
        style.maximumLineHeight = 15
        
        return style.copy() as! NSParagraphStyle
    }
    
    static var attributes: [String: Any] {
        
        return [NSFontAttributeName: self.font,
                NSParagraphStyleAttributeName: self.style]
    }
}

extension LabelCell: SizeLayout {
    
    typealias SizeContext = NSString
    
    static func size(using context: NSString,
                     boundingSize: CGSize) -> CGSize {
        
        let rect = context.boundingRect(with: boundingSize,
                                        options: [.usesLineFragmentOrigin,
                                                  .usesFontLeading],
                                        attributes: self.attributes,
                                        context: nil)
        
        let inset =  LabelCell.inset + LabelCell.inset + LabelCell.inset // will be fixed
        
        return CGSize(width: rect.size.width + inset,
                      height: rect.size.height)
    }
}

protocol LabelCellConfigurator {
    
    var text: String? { get }
}

extension LabelCell: CellConfiguration {
    
    typealias Configurator = LabelCellConfigurator
    
    func configure(with configurator: Configurator) {
        
        if let text = configurator.text {
            
            self.label.attributedText = NSAttributedString(string: text, attributes: LabelCell.attributes)
            
        } else {
            
            self.label.attributedText = nil
        }
    }
}

