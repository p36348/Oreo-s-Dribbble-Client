//
//  NSAttributedStringFactory.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 16/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit


/// 富文本样式枚举
///
/// - textColor: 文本颜色
/// - font: 文本字体
/// - paragraphStyle: 段落样式
/// - underLine: 下划线
public enum AttributedStringOptions {
    case textColor(UIColor)
    case font(UIFont)
    case paragraphStyle(lineSpacing: CGFloat?, alignment: NSTextAlignment?)
    case indent(head: CGFloat, tail: CGFloat)
    case underLine(NSUnderlineStyle?,  UIColor?)
}

public var defaultFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)

extension String {
    public func attributedString(font: UIFont = defaultFont, color: UIColor = UIColor.black, alignment: NSTextAlignment? = nil) -> NSMutableAttributedString {
        
        return self.attributed([.font(font), .textColor(color), .paragraphStyle(lineSpacing: nil, alignment: alignment)])
    }
    
    public func attributed(_ options: [AttributedStringOptions] = [.font(defaultFont), .textColor(UIColor.black), .paragraphStyle(lineSpacing: nil, alignment: nil)]) -> NSMutableAttributedString {
        
        var attributes: [NSAttributedStringKey: Any] = [:]
        
        var textColor: UIColor = UIColor.black
        
        var textFont: UIFont = defaultFont
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        options.forEach { (option) in
            switch option {
            case .textColor(let color):
                textColor = color
            case .font(let font):
                textFont = font
            case .paragraphStyle(let lineSpacing, let alignment):
                if let _alignment = alignment {
                    paragraphStyle.alignment = _alignment
                }
                if let _lineSpacing = lineSpacing {
                    paragraphStyle.lineSpacing = _lineSpacing
                }
            case .indent(let head, let tail):
                paragraphStyle.firstLineHeadIndent = head
                paragraphStyle.headIndent = head
                paragraphStyle.tailIndent = tail
            case .underLine(let style, let color):
                if let _style = style {
                    attributes[NSAttributedStringKey.underlineStyle] = _style.rawValue
                }
                if let _color = color {
                    attributes[NSAttributedStringKey.underlineColor] = _color
                }
            }
        }
        // fix
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        
        attributes[NSAttributedStringKey.foregroundColor] = textColor
        
        attributes[NSAttributedStringKey.font] = textFont
        
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}

extension NSMutableAttributedString {
    public func appending(_ attr: NSAttributedString) -> NSMutableAttributedString {
        self.append(attr)
        return self
    }
}

public func +<T: NSMutableAttributedString>(left: T, right: NSAttributedString) -> T {
        left.append(right)
        return  left
}

public func +<T: NSMutableAttributedString>(left: T, option: AttributedStringOptions) -> T {
    left.enumerateAttributes(in: NSRange(location: 0, length: left.string.count), options: []) { [weak left] (originalAttribute, range, ptr) in
        var newAttribute = originalAttribute
        
        let paragraphStyle = (newAttribute[NSAttributedStringKey.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        
        switch option {
        case .textColor(let color):
            newAttribute[NSAttributedStringKey.foregroundColor] = color
        case .font(let font):
            newAttribute[NSAttributedStringKey.font] = font
        case .paragraphStyle(let lineSpacing, let alignment):
            if let _alignment = alignment {
                paragraphStyle.alignment = _alignment
            }
            if let _lineSpacing = lineSpacing {
                paragraphStyle.lineSpacing = _lineSpacing
            }
        case .indent(let head, let tail):
            paragraphStyle.firstLineHeadIndent = head
            paragraphStyle.headIndent = head
            paragraphStyle.tailIndent = tail
        case .underLine(let style, let color):
            if let _style = style {
                newAttribute[NSAttributedStringKey.underlineStyle] = _style.rawValue
            }
            if let _color = color {
                newAttribute[NSAttributedStringKey.underlineColor] = _color
            }
        }
        left?.addAttributes(newAttribute, range: range)
    }
    return left
}
