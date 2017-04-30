//
//  ViewController.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 28.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

private let kMinCellWidth: CGFloat = 60
private let kMaxCellWidth: CGFloat = 120

extension String: LabelCellConfigurator {
    
    var text: String? {
        
        return self
    }
}

extension UIImage: ImageCellConfigurator {
    
    var image: UIImage? {
        
        return self
    }
}

struct ImageText {
    
    let imageValue: UIImage
    let textValue: String
}

extension ImageText: ImageLabelCellConfigurator {
    
    var text: String? {
        
        return self.textValue
    }
    
    var image: UIImage? {
        
        return self.imageValue
    }
}

let kBigImage = UIImage(named: "big_image")!
let kSmallImage = UIImage(named: "small_image")!
let kSectionHeight: CGFloat = 50

class ViewController: UIViewController {
    
    let cellTypes: [ScrollBarCellType] = [.label, .smallImage, .bigImage, .imageLabel]
    
    let items: [[Any]] = [
        ["A", "ABC", "Title", "Double Title", "Very Long Title", "Very Very Very Long Title"],
        
        [kSmallImage, kSmallImage],
        [kBigImage, kBigImage],
        
        [ImageText(imageValue: kSmallImage, textValue: "A"),
         ImageText(imageValue: kSmallImage, textValue: "ABC"),
         ImageText(imageValue: kSmallImage, textValue: "Title"),
         ImageText(imageValue: kSmallImage, textValue: "Double Title"),
         ImageText(imageValue: kSmallImage, textValue: "Very Long Title"),
         ImageText(imageValue: kSmallImage, textValue: "Very Very Very Long Title")],
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        self.title = "Dynamic sizes"
        
        let arrangedSubviews = (0..<self.items.count).map({ (tag) -> UIView in
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
            
            let scrollBarController = ScrollBarController(collectionViewLayout: layout)
            scrollBarController.dataSource = self
            
            let traitCollection =
                UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular),
                                               UITraitCollection(verticalSizeClass: .compact)])
            
            self.addChildViewController(scrollBarController)
            self.setOverrideTraitCollection(traitCollection, forChildViewController: scrollBarController)
            scrollBarController.didMove(toParentViewController: self)
            
            let v = scrollBarController.view!
            v.tag = tag
            v.translatesAutoresizingMaskIntoConstraints = false
            v.heightAnchor.constraint(equalToConstant: kSectionHeight).isActive = true
            
            return v
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
}

extension ViewController: ScrollBarDataSource {
    
    func numberOfItems(in scrollBarController: ScrollBarController) -> Int {
        
        return self.items[scrollBarController.view.tag].count
    }
    
    func scrollBarController(_ scrollBarController: ScrollBarController, cellTypeAt item: Int) -> ScrollBarCellType {
        
        return self.cellTypes[scrollBarController.view.tag]
    }
    
    func scrollBarController<T>(_ scrollBarController: ScrollBarController, layout: T.Type, height: CGFloat, widthForCellAt item: Int) -> CGSize where T : SizeLayout {
        
        let tag = scrollBarController.view.tag
        let item = self.items[tag][item]
        let boundingSize = CGSize(width: kMaxCellWidth, height: height)
        
        let width = layout.size(using: item as! T.SizeContext, boundingSize: boundingSize).width.validate(range: kMinCellWidth...kMaxCellWidth)
        
        return CGSize(width: width, height: height)
    }
    
    func scrollBarController<T>(_ scrollBarController: ScrollBarController, configureCell cell: T, at item: Int) where T : CellConfiguration {
        
        let tag = scrollBarController.view.tag
        let configurator = self.items[tag][item]
        
        cell.configure(with: configurator as! T.Configurator)
    }
}
