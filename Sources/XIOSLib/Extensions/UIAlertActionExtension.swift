//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

extension UIAlertAction {
    func setSystemImageName(_ name: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        self.setValue(UIImage(systemName: name, withConfiguration: config), forKey: "image")
        self.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
    }
}

