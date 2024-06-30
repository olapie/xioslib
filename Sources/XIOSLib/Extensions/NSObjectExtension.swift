//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import Foundation

extension NSObject {
    var className: String {
        get {
            return String(describing: self.self)
        }
    }
}
