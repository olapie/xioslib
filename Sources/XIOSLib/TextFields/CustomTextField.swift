//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import UIKit


let CustomTextFieldBackgroundImageViewTag = 12389

@IBDesignable
open class CustomTextField: UITextField {
    @IBInspectable
    var horizontalTextPadding: CGFloat = 8
    private var addedBackground = false

    public override func didMoveToSuperview() {
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
        backgroundImageView.edgesEqualToView(self)
    }
    
  
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: horizontalTextPadding, dy: 0)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.insetBy(dx: horizontalTextPadding, dy: 0)
    }
}
