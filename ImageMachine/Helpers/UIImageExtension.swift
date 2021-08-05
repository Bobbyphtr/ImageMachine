//
//  UIImageExtension.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import UIKit
import Foundation

extension UIImage {
    
    func generateThumbnail()->UIImage {
        let imageData = self.pngData()
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
        let source = CGImageSourceCreateWithData(imageData! as CFData, nil)
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source!, 0, options)!
       return UIImage(cgImage: imageReference)
        
    }
}
