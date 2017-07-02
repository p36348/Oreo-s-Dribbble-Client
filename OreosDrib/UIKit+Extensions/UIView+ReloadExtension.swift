//
//  UIView+ReloadExtension.swift
//  Mazing
//
//  Created by P36348 on 1/9/17.
//  Copyright © 2017 Mazing. All rights reserved.
//

import UIKit

// MARK: - 重新加载
extension UIView {
    
    
    open func addClickToReload(withImage image: UIImage = UIImage(named: "Reload")!, title: String = "网络出错,点击重试", offsetY: CGFloat = 0, action: ()->Void){
        if reloadView.superview == nil {
            
            reloadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIView.userDidTapReloadView(sender:))))
            addSubview(reloadView)
            reloadView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self).offset(offsetY)
            }
        }
        
        reloadView.imageView.image = image
        reloadView.titleLabel.text = title
        objc_setAssociatedObject(self, &actionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        hideReload()
    }
    
    
    open func showReload(){
        reloadView.isHidden = false
        if let scrollView = self as? UIScrollView  {
            scrollView.isScrollEnabled = false
        }
    }
    
    
    open func hideReload(){
        reloadView.isHidden = true
        if let scrollView = self as? UIScrollView  {
            scrollView.isScrollEnabled = true
        }
    }
    
    
    dynamic private func userDidTapReloadView(sender: UIGestureRecognizer) {
        guard sender.view == reloadView else { return }
        hideReload()
        reloadAction?()
    }
}

private var reloadViewKey = 0

private var actionKey = 0


extension UIView {
    fileprivate var reloadView: ReloadView {
        get {
            if let _reloadView = objc_getAssociatedObject(self, &reloadViewKey) as? ReloadView {
                return _reloadView
            }else {
                let _reloadView = ReloadView(frame: .zero)
                objc_setAssociatedObject(self, &reloadViewKey, _reloadView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return _reloadView
            }
        }
    }
    
    
    fileprivate var reloadAction: (()->Void)? {
        get {
            return objc_getAssociatedObject(self, &actionKey) as? (()->Void)
        }
    }
}

extension UIView {
    fileprivate class ReloadView: UIView {
        var imageView: UIImageView = UIImageView()
        var titleLabel: UILabel = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(imageView)
            addSubview(titleLabel)
            imageView.snp.makeConstraints { (make) in
                make.center.equalTo(self)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.leading.bottom.trailing.equalTo(self)
                make.top.equalTo(imageView.snp.bottom).offset(10)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
