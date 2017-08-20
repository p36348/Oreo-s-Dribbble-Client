//
//  ViewModel+Configuration.swift
//  RacSwift
//
//  Created by P36348 on 5/31/17.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

protocol CellViewModel: class {
    /// 对应的tableViewCell的指针
    var cellClass: AnyClass {get}
}

protocol TableCellViewModel: CellViewModel {
    /// viewModel对应tableViewCell的高度
    var height: CGFloat {get}
}

protocol CollectionCellViewModel: CellViewModel {
    var size: CGSize {get}
    
}

protocol SectionHeaderFooterViewModel: class {
    
}

protocol SectionHeaderFooter: class {
    
    var viewModel: SectionHeaderFooterViewModel? {get set}
    
    func update() -> Void
    
    func endUpdate() -> Void
}

extension UITableViewHeaderFooterView: SectionHeaderFooter {
    
    var viewModel: SectionHeaderFooterViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewModelKey) as? SectionHeaderFooterViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func update() {
        
    }
    
    
    func endUpdate() {
        
    }
}



protocol CollectionCellDelegate: class {
    
}

protocol Cell: class {
    func prepare() -> Void
    
    func update() -> Void
    
    func endUpdate() -> Void
}

protocol CollectionCell: Cell {
    
    var viewModel: CollectionCellViewModel? { get set }
    
    var delegate: CollectionCellDelegate? { get set }
}

protocol TableCell: Cell {
    var viewModel: TableCellViewModel? { get set }
}

extension UITableViewCell: TableCell {
    
    var viewModel: TableCellViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewModelKey) as? TableCellViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func prepare() {}
    
    func update() {}
    
    func endUpdate() {}
}

private var viewModelKey: Int = 0

private var delegateKey: Int = 0

extension UICollectionViewCell: CollectionCell {
    
    var delegate: CollectionCellDelegate? {
        get {
            return objc_getAssociatedObject(self, &delegateKey) as? CollectionCellDelegate
        }
        set {
            objc_setAssociatedObject(self, &delegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    var viewModel: CollectionCellViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewModelKey) as? CollectionCellViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func prepare() {}
    
    func update() {}
    
    func endUpdate() {}
}
