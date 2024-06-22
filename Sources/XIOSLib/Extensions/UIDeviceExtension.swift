//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
           $0.withMemoryRebound(to: CChar.self, capacity: 1) {
               ptr in String.init(validatingUTF8: ptr)
           }
        }
        return modelCode ?? self.model
    }
    
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
