//
//  Image+Handle.swift
//  OreosDrib
//
//  Created by P36348 on 22/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

/// 图像处理
extension UIImage {
    
    var faceFeatures: [CIFaceFeature] {
        return self.features(of: CIDetectorTypeFace) as! [CIFaceFeature]
    }
    
    var qrCodeFeatures:[CIQRCodeFeature] {
        return self.features(of: CIDetectorTypeQRCode) as! [CIQRCodeFeature]
    }
}

// MARK: - 识别
extension UIImage {
    fileprivate func features(of type: String) -> [CIFeature] {
        
        guard let _image: CGImage = self.cgImage else { return [] }
        
        let context: CIContext = CIContext()
        
        guard let detector: CIDetector = CIDetector(ofType: type, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else { return [] }
        
        return detector.features(in: CIImage(cgImage: _image))
    }
}

// MARK: - 滤镜
extension UIImage {
    func filter(with filterName: String) -> UIImage {
        
        guard let filter: CIFilter = CIFilter(name: filterName) else { return self }
        
        filter.setValue(self, forKey: kCIInputImageKey)
        
        guard let output = filter.outputImage else { return self }
        
        return UIImage(ciImage: output)
    }
}
