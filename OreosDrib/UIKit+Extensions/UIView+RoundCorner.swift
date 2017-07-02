//
//  UIView+RoundCorner.swift
//  OreosDrib
//
//  Created by P36348 on 11/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation

import UIKit

/*
 * 圆角添加 定size可以1次添加1张图,动态size需要分开4个角落添加
 * 取经于:http://www.jianshu.com/p/f970872fdc22
 * https://github.com/bestswifter/MySampleCode/blob/master/CornerRadius/CornerRadius/KtCorner.swift
 */

/// 默认圆角弧度
private let defaultRadius: CGFloat = 8.0

typealias Corners = (topLeft: UIImageView, bottomLeft: UIImageView, topRight: UIImageView, bottomRight: UIImageView)

func makeCorners(radius: CGFloat = defaultRadius,
                 borderWidth: CGFloat = 0,
                 borderColor: UIColor = UIColor.white,
                 backgroundColor aBackgroundColor: UIColor = UIColor.white) -> Corners {
    
    var topLeft: UIImage?, bottomLeft: UIImage?, topRight: UIImage?, bottomRight: UIImage?
    
    let _size: CGSize = CGSize(width: pixel(radius), height: pixel(radius))
    let (width, height): (CGFloat, CGFloat) = (_size.width, _size.height)
    
    UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
    
    guard let context = UIGraphicsGetCurrentContext() else { return (UIImageView(), UIImageView(), UIImageView(), UIImageView()) }
    
    context.setFillColor(aBackgroundColor.cgColor)
    
    context.setStrokeColor(borderColor.cgColor)
    
    context.move(to: CGPoint(x: width, y: height))
    context.addArc(center: CGPoint.zero, radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi*2), clockwise: true) // 右下角
    context.drawPath(using: .fillStroke)
    bottomRight = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
    let _context = getContext(borderColor: borderColor, backgroundColor: aBackgroundColor)!
    _context.move(to: CGPoint(x: 0, y: height))
    _context.addArc(center: CGPoint(x: width, y: 0), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: false) // 左下角
    _context.drawPath(using: .fillStroke)
    bottomLeft = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
    let __context = getContext(borderColor: borderColor, backgroundColor: aBackgroundColor)!
    __context.move(to: CGPoint.zero)
    __context.addArc(center: CGPoint(x: width, y: height), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3/2), clockwise: false) // 左上角
    __context.drawPath(using: .fillStroke)
    topLeft = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
     let ___context = getContext(borderColor: borderColor, backgroundColor: aBackgroundColor)!
    ___context.move(to: CGPoint(x: width, y: 0))
    ___context.addArc(center: CGPoint(x: 0, y: height), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 3/2), clockwise: true) // 右上角
    ___context.drawPath(using: .fillStroke)
    topRight = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return (UIImageView(image: topLeft), UIImageView(image: bottomLeft), UIImageView(image: topRight), UIImageView(image: bottomRight))
}

private func getContext(borderColor: UIColor,
                        backgroundColor: UIColor) -> CGContext? {
    let _context = UIGraphicsGetCurrentContext()
    _context?.setFillColor(backgroundColor.cgColor)
    _context?.setStrokeColor(borderColor.cgColor)
    return _context
}

private func roundbyunit(px: Double,unit: inout Double) -> Double {
    let remain = modf(px, &unit)
    if (remain > unit / 2.0) {
        return ceilbyunit(px: px, unit: &unit)
    } else {
        return floorbyunit(px: px, unit: &unit)
    }
}

private func ceilbyunit(px: Double,unit: inout Double) -> Double {
    return px - modf(px, &unit) + unit
}

private func floorbyunit(px: Double,unit: inout Double) -> Double {
    return px - modf(px, &unit)
}

private func pixel(_ px: CGFloat) -> Double {
    let _px = Double(px)
    var unit: Double
    switch Int(UIScreen.main.scale) {
    case 1: unit = 1.0 / 1.0
    case 2: unit = 1.0 / 2.0
    case 3: unit = 1.0 / 3.0
    default: unit = 0.0
    }
    return roundbyunit(px: _px, unit: &unit)
}

extension UIView {
    
    /// 添加4个圆角
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - borderWidth: 圆角边缘宽度
    ///   - borderColor: 圆角边缘颜色
    ///   - aBackgroundColor: 圆角底色
    func addRoundCorners(radius: CGFloat = defaultRadius,
                        borderWidth: CGFloat = 1.0,
                        borderColor: UIColor = UIColor.white,
                        backgroundColor aBackgroundColor: UIColor = UIColor.white) {
        
        let corners = makeCorners()
        
        insertSubview(corners.topLeft, at: 0)
        insertSubview(corners.topRight, at: 0)
        insertSubview(corners.bottomLeft, at: 0)
        insertSubview(corners.bottomRight, at: 0)
        corners.topLeft.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
        }
        corners.topRight.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
        }
        corners.bottomLeft.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(0)
        }
        corners.bottomRight.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
        }
    }
}

extension UIImageView {
    override func addRoundCorners(radius: CGFloat = defaultRadius,
                                 borderWidth: CGFloat = 1.0,
                                 borderColor: UIColor = UIColor.white,
                                 backgroundColor aBackgroundColor: UIColor = UIColor.white) {
        image = image?.roundCornerImage(radius: radius, size: bounds.size)
        
    }
}

extension UIImage {
    fileprivate func roundCornerImage(radius: CGFloat, size: CGSize) -> UIImage? {
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let rect: CGRect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        context.addPath(UIBezierPath(roundedRect: rect,
                                     byRoundingCorners: UIRectCorner.allCorners,
                                     cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        context.clip()
        
        draw(in: rect)
        context.drawPath(using: .fillStroke)
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return _image
    }
}
