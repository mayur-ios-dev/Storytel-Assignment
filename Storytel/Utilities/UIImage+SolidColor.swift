//
//  UIImage+SolidColor.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import UIKit

extension UIImage {
    static func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return UIImage() }
        return UIImage(cgImage: cgImage)
    }
}
