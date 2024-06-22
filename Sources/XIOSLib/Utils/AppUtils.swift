//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import UIKit


func dismissKeyboard() {
    getKeywindow()?.endEditing(true)
}

func getKeywindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes
    guard let windowScene = scenes.first as? UIWindowScene else {
        return nil
    }
    
    let keyWindows = windowScene.windows.filter{$0.isKeyWindow}
    return keyWindows.first
}



func openSystemSettings() {
    let url = URL(string: UIApplication.openSettingsURLString)!
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}

func openAudioSettings() {
    let c = UIAlertController(title: Translate("MicPermissionAlertTitle"), message: "", preferredStyle: .alert)
    c.addAction(UIAlertAction(title: Translate("Cancel"), style: .cancel, handler: nil))
    c.addAction(UIAlertAction(title: Translate("Settings"), style: .`default`, handler: {_ in openSystemSettings()}))
    getKeywindow()?.rootViewController?.present(c, animated: true, completion: nil)
}

func popToRoot() {
    NavigationUtil.popToRootView()
}

struct NavigationUtil {
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        if let navigationController = viewController as? UINavigationController {
                    return navigationController
                }
        for childViewController in viewController.children {
                    return findNavigationController(viewController: childViewController)
                }
        return nil
    }
}
