//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import UIKit

extension UIWindow {
    static func getKeywindow() -> UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else {
            return nil
        }
        
        let keyWindows = windowScene.windows.filter{$0.isKeyWindow}
        return keyWindows.first
    }
}


