//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

public extension UITextView {
    func trimmedText() -> String {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
