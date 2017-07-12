//
//  HTMLParser.swift
//  OreosDrib
//
//  Created by P36348 on 12/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import CoreText
import Kanna
class HTMLParser {
    var attrString: NSAttributedString = NSAttributedString()
    
    func parse(html: String) {
        guard let _data = html.data(using: String.Encoding.utf8) else { return }
        do {
            attrString = try NSAttributedString(data: _data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch {
        
        }
    }
}
