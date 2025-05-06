//
//  ViewController.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 28.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController {
    struct Constants {
        public static let minCellWidth: CGFloat = 64
        public static let maxCellWidth: CGFloat = 120
        public static let sectionHeight: CGFloat = 50
        
        public static let bigImage = UIImage(named: "big_image")!
        public static let smallImage = UIImage(named: "small_image")!
    }
    
    let items: [(type: ScrollBarCellType, array: [Any])] = [
        (.label, ["A", "ABC", "Title", "Double Title", "Very Long Title", "Very Very Very Long Title"]),
        
        (.label, ["FOREX", "STOCKS", "FOREX"]),
        
        (.smallImage, [Constants.smallImage, Constants.smallImage]),
        (.bigImage, [Constants.bigImage, Constants.bigImage]),
        
        (.imageLabel, [ImageText(imageValue: Constants.smallImage, textValue: "A"),
         ImageText(imageValue: Constants.smallImage, textValue: "ABC"),
         ImageText(imageValue: Constants.smallImage, textValue: "Title"),
         ImageText(imageValue: Constants.smallImage, textValue: "Double Title"),
         ImageText(imageValue: Constants.smallImage, textValue: "Very Long Title"),
         ImageText(imageValue: Constants.smallImage, textValue: "Very Very Very Long Title")]),
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
            
            self.addChild(scrollBarController)
            let v = scrollBarController.view!
            v.traitOverrides.horizontalSizeClass = .regular
            v.traitOverrides.verticalSizeClass = .compact
            v.tag = tag
            v.translatesAutoresizingMaskIntoConstraints = false
            v.heightAnchor.constraint(equalToConstant: Constants.sectionHeight).isActive = true
            scrollBarController.didMove(toParent: self)
            
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
        return self.items[scrollBarController.view.tag].array.count
    }
    
    func scrollBarController(_ scrollBarController: ScrollBarController, cellTypeAt item: Int) -> ScrollBarCellType {
        return self.items[scrollBarController.view.tag].type
    }
    
    func scrollBarController<T>(_ scrollBarController: ScrollBarController, layout: T.Type, height: CGFloat, widthForCellAt item: Int) -> CGSize where T : SizeLayout {
        
        let tag = scrollBarController.view.tag
        let item = self.items[tag].array[item]
        let boundingSize = CGSize(width: Constants.maxCellWidth, height: height)
        let width = DynamicCellWidth.validate(layout.size(using: item as! T.SizeContext, boundingSize: boundingSize).width,
                                              in: Constants.minCellWidth...Constants.maxCellWidth)
        
        return CGSize(width: width, height: height)
    }
    
    func scrollBarController<T>(_ scrollBarController: ScrollBarController, configureCell cell: T, at item: Int) where T : CellConfiguration {
        let tag = scrollBarController.view.tag
        let configurator = self.items[tag].array[item]
        
        cell.configure(with: configurator as! T.Configurator)
    }
}
