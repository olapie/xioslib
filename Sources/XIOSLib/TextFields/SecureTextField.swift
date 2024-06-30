//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import UIKit

open class SecureTextField: CustomTextField {
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = .systemFont(ofSize: 21)
        self.textAlignment = .center
        self.keyboardType = .numberPad
        self.isSecureTextEntry = true
    }
}

