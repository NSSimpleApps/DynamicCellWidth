//
//  ScrollBarController.swift
//  DynamicCellWidth
//
//  Created by NSSimpleApps on 28.04.17.
//  Copyright © 2017 NSSimpleApps. All rights reserved.
//

import UIKit

enum ScrollBarCellType {
    
    case bigImage
    case smallImage
    case label
    case imageLabel
}

protocol ScrollBarDataSource: class {
    
    func numberOfItems(in scrollBarController: ScrollBarController) -> Int
    
    func scrollBarController(_ scrollBarController: ScrollBarController,
                             cellTypeAt item: Int) -> ScrollBarCellType
    
    func scrollBarController<T: SizeLayout>(_ scrollBarController: ScrollBarController,
                             layout: T.Type,
                             height: CGFloat,
                             widthForCellAt item: Int) -> CGSize
    
    func scrollBarController<T: CellConfiguration>(_ scrollBarController: ScrollBarController,
                             configureCell cell: T,
                             at item: Int)
}

class ScrollBarController: UICollectionViewController {
    
    weak var dataSource: ScrollBarDataSource?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.register(cellClass: LabelCell.self)
        self.collectionView?.register(cellClass: SmallImageCell.self)
        self.collectionView?.register(cellClass: BigImageCell.self)
        self.collectionView?.register(cellClass: ImageLabelCell.self)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource?.numberOfItems(in: self) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = self.dataSource!.scrollBarController(self, cellTypeAt: indexPath.item)
        
        switch cellType {
            
        case .bigImage:
            let bigImageCell = collectionView.dequeueReusableCell(withCellClass: BigImageCell.self, for: indexPath)
            self.dataSource?.scrollBarController(self, configureCell: bigImageCell, at: indexPath.item)
            
            return bigImageCell
            
        case .smallImage:
            let smallImageCell = collectionView.dequeueReusableCell(withCellClass: SmallImageCell.self, for: indexPath)
            self.dataSource?.scrollBarController(self, configureCell: smallImageCell, at: indexPath.item)
            
            return smallImageCell
            
        case .label:
            let labelCell = collectionView.dequeueReusableCell(withCellClass: LabelCell.self, for: indexPath)
            self.dataSource?.scrollBarController(self, configureCell: labelCell, at: indexPath.item)
            
            return labelCell
            
        case .imageLabel:
            let imageLabelCell = collectionView.dequeueReusableCell(withCellClass: ImageLabelCell.self, for: indexPath)
            self.dataSource?.scrollBarController(self, configureCell: imageLabelCell, at: indexPath.item)
            
            return imageLabelCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(collectionView.cellForItem(at: indexPath)!.frame.size, indexPath)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionViewLayout.invalidateLayout()
    }
}

extension ScrollBarController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let dataSource = self.dataSource {
            
            let type = dataSource.scrollBarController(self, cellTypeAt: indexPath.item)
            let height = collectionView.bounds.height
            
            switch type {
            
            case .label:
                return dataSource.scrollBarController(self, layout: LabelCell.self, height: height, widthForCellAt: indexPath.item)
                
            case .bigImage:
                return dataSource.scrollBarController(self, layout: BigImageCell.self, height: height, widthForCellAt: indexPath.item)
                
            case .smallImage:
                return dataSource.scrollBarController(self, layout: SmallImageCell.self, height: height, widthForCellAt: indexPath.item)
                
            case .imageLabel:
                return dataSource.scrollBarController(self, layout: ImageLabelCell.self, height: height, widthForCellAt: indexPath.item)
            }
            
        } else {
            
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let collectionViewWidth = collectionView.bounds.width
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInset = flowLayout.sectionInset
        
        var totalWidth: CGFloat = 0
        
        for item in 0..<numberOfItems {
            
            totalWidth += self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: item, section: section)).width + flowLayout.minimumInteritemSpacing
            
            if totalWidth >= collectionViewWidth {
                
                return sectionInset
            }
        }
        
        let inset = (collectionViewWidth - totalWidth) / 2
        
        return UIEdgeInsets(top: sectionInset.top,
                            left: inset,
                            bottom: sectionInset.bottom,
                            right: inset)
    }
}


