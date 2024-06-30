//
//  File.swift
//  
//
//  Created by tan on 2024-06-21.
//

import UIKit

open class XReplaceStoryboardSegue: UIStoryboardSegue {
    @IBInspectable var animated = true
    
    open override func perform() {
        guard let navigationController = self.source.navigationController else {
            return
        }
        var controllers = navigationController.viewControllers
        if controllers.last != self.source {
            return
        }
        controllers.removeLast()
        controllers.append(self.destination)
        navigationController.setViewControllers(controllers, animated: self.animated)
    }
}
