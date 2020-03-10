//
//  UIImage+Extentions.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/10/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
  static func resizeImage(originalImage: UIImage, rect: CGRect) -> UIImage {
    let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
    let size = CGSize(width: rect.width, height: rect.height)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
      originalImage.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
