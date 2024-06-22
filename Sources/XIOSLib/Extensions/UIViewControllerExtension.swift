//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit


protocol InstantiatableViewController {
    func instantiateViewController() -> Self
}

extension UIViewController {
    @objc class func instantiateViewController() -> Self {
        if let _ = self as? InstantiatableViewController {
            return wrapperInstantiateViewController()
        }
        let className = NSStringFromClass(self).split(separator: ".").last!
        var storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        if storyboardName == className {
            storyboardName = className.replacingOccurrences(of: "Controller", with: "")
        }
        return instantiateViewController(storyboardName, identifier: nil)
    }

    class func wrapperInstantiateViewController<T>() -> T {
        let instatiator = self as! InstantiatableViewController
        return instatiator.instantiateViewController() as! T
    }

    class func instantiateInitialViewController() -> UIViewController {
        let className = NSStringFromClass(self).split(separator: ".").last!
        var storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        if storyboardName == className {
            storyboardName = className.replacingOccurrences(of: "Controller", with: "")
        }
        return instantiateViewController(storyboardName, identifier: nil)
    }

    class func instantiateViewController<T>(_ storyboardName: String, identifier: String?) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let id = identifier {
            return storyboard.instantiateViewController(withIdentifier: id) as! T
        }

        if let controller = storyboard.instantiateInitialViewController() as? T {
            return controller
        }

        let className = NSStringFromClass(self).split(separator: ".").last!
        var id = className.replacingOccurrences(of: "ViewController", with: "")
        if id == className {
            id = className.replacingOccurrences(of: "Controller", with: "")
        }
        return storyboard.instantiateViewController(withIdentifier: id) as! T
    }
}
