//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

extension UIView {
    func superTableViewCell() -> UITableViewCell? {
        var v: UIView? = self
        while v != nil {
            if let cell = v as? UITableViewCell {
                return cell
            }
            v = v?.superview
        }
        return nil
    }

    func superCollectionViewCell() -> UICollectionViewCell? {
        var v: UIView? = self
        while v != nil {
            if let cell = v as? UICollectionViewCell {
                return cell
            }
            v = v?.superview
        }
        return nil
    }

    func setTintColorR(_ color: UIColor) {
        tintColor = color
        if let label = self as? UILabel {
            label.textColor = color
        }
        for v in subviews {
            v.setTintColorR(color)
        }
    }
}
