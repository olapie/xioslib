//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import UIKit


let CustomTextFieldBackgroundImageViewTag = 12389

@IBDesignable
class CustomTextField: UITextField {
    @IBInspectable
    var horizontalTextPadding: CGFloat = 8
    private var addedBackground = false

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.borderStyle = .none
        if addedBackground {
            return
        }
        addedBackground = true
        let image = UIImage(systemName: "rectangle")?.resizableImage(withCapInsets: .init(top: 4, left: 4, bottom: 4, right: 4), resizingMode: .stretch)
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleToFill
        superview!.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.leadingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: superview!.layoutMarginsGuide.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: superview!.layoutMarginsGuide.bottomAnchor).isActive = true
       
    }
    
  
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: horizontalTextPadding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.insetBy(dx: horizontalTextPadding, dy: 0)
    }
}
