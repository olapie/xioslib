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
    
    func widthEqualTo(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func widthEqualTo(_ view: UIView, offset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor, constant: offset).isActive = true
    }
    
    func widthEqualTo(_ width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    
    func widthEqualToSuperview() {
        guard let v = self.superview else {
            return
        }
        self.widthEqualTo(v)
    }
    
    func heightEqualTo(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func heightEqualTo(_ view: UIView, offset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, constant: offset).isActive = true
    }
    
    func heightEqualTo(_ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    
    func heightEqualToSuperview() {
        guard let v = self.superview else {
            return
        }
        self.heightEqualTo(v)
    }
    
    
    func sizeEqualToSuperview() {
        guard let v = self.superview else {
            return
        }
        self.sizeEqualTo(v)
    }
    
    func sizeEqualTo(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func centerEqualToSuperview() {
        guard let v = self.superview else {
            return
        }
        self.centerEqualToView(v)
    }
    
    func centerEqualToView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func edgesEqualToSuperview() {
        guard let v = self.superview else {
            return
        }
        self.edgesEqualToView(v)
    }
    
    func edgesEqualToView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    func sizeEqualTo(_ width: CGFloat, _ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    
    func printSubViews(_ indence: String) {
        print(indence + self.description)
        let subIndence = "  " + indence
        self.subviews.forEach { v in
            v.printSubViews(subIndence)
        }
    }
}
