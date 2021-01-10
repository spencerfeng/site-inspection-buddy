//
//  Helper.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 10/1/21.
//

import Foundation
import UIKit

class Helper {
    static func getThumbnailForImage(imageData: Data, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) * scale
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }
        
        return UIImage(cgImage: image)
    }
}
