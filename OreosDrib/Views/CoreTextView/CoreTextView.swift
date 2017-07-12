//
//  CoreTextView.swift
//  OreosDrib
//
//  Created by P36348 on 22/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import CoreText

/**
 * https://www.raywenderlich.com/153591/core-text-tutorial-ios-making-magazine-app
 */

class CoreTextView: UIView {
    
    // MARK: - Properties
    var attrString: NSAttributedString = NSAttributedString()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func importAttrString(_ attrString: NSAttributedString) {
        self.attrString = attrString
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        // 2
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        // 3
        let path = CGMutablePath()
        path.addRect(bounds)
        // 4
//        let attrString = NSAttributedString(string: "Hello World")
        // 5
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        // 6
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        // 7
        CTFrameDraw(frame, context)
        
    }
}
