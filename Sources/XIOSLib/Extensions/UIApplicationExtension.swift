//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import UIKit

public extension UIApplication {
    public static func openSystemSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    public static func dismissKeyboard() {
        UIWindow.getKeywindow()?.endEditing(true)
    }


    public static func openAudioSettings() {
        let c = UIAlertController(title: Translate("MicPermissionAlertTitle"), message: "", preferredStyle: .alert)
        c.addAction(UIAlertAction(title: Translate("Cancel"), style: .cancel, handler: nil))
        c.addAction(UIAlertAction(title: Translate("Settings"), style: .`default`, handler: {_ in openSystemSettings()}))
        UIWindow.getKeywindow()?.rootViewController?.present(c, animated: true, completion: nil)
    }
}
