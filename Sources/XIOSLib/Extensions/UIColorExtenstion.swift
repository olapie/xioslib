//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

public extension UIColor {
    convenience init(rgb: Int) {
        let r = CGFloat(rgb >> 16) / 255.0
        let g = CGFloat(rgb >> 8 & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    class func appTitle() -> UIColor {
        return UIColor(rgb: 0x161616)
    }

    class func appText() -> UIColor {
        return UIColor.darkText
    }

    class func appGray() -> UIColor {
        return UIColor.gray
    }

    class func appHighlighted() -> UIColor {
        return UIColor.link.withAlphaComponent(0.85)
    }

    class func appBgColor() -> UIColor {
//        return UIColor(red: 0xEB/CGFloat(0xFF), green: 0xEB/CGFloat(0xFF), blue: 0xF1/CGFloat(0xFF), alpha: 1.0)
        return UIColor.white
    }

    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
