//
//  HTMLParser.swift
//  OreosDrib
//
//  Created by P36348 on 12/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

class HTMLParser {
    
    var attrString: NSAttributedString = NSAttributedString()
    
    func parse(html: String) {
        guard let _data = html.data(using: String.Encoding.utf8) else { return }
        do {
            var dic: NSDictionary? = [:]
            let _attrString = try NSAttributedString(data: _data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentAttributeKey.documentType], documentAttributes: &dic)
//                NSAttributedString(data: _data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
//                                                     documentAttributes: &dic)

            let finalAttributedString = NSMutableAttributedString(string: _attrString.string)
            
//            _attrString.enumerateAttributes(in: NSRange(location: 0, length: _attrString.string.characters.count), options: [], using: { (attribute, range, ptr) in
//                var _attribute = attribute
//                
//                if _attribute[NSLinkAttributeName] != nil {
//                    _attribute[NSFontAttributeName] = UIFont.link
//                    _attribute.removeValue(forKey: NSUnderlineStyleAttributeName)
//                    _attribute.removeValue(forKey: NSLinkAttributeName)
//                    _attribute[NSForegroundColorAttributeName] = UIColor.Dribbble.linkBlue
//                }else {
//                    let originFont =  _attribute[NSFontAttributeName] as! UIFont
//                    _attribute[NSFontAttributeName] = originFont.fontName.contains("Bold") ? UIFont.contentBold : UIFont.contentNormal
//                }
//                finalAttributedString.addAttributes(_attribute, range: range)
//                
//            })
            
            self.attrString = finalAttributedString
            
        }catch {
        
        }
    }
    
    func parse(html: String, completion: @escaping ()->Void) {
        DispatchQueue.global().async {
            self.parse(html: html)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
