//
//  ReachabilityController.swift
//  Secret
//
//  Created by tan on 2024-06-18.
//

import UIKit
import Reachability

open class WifiDetector {
    let reachability = try! Reachability()
    var callback: ((_ wifiEnabled: Bool)->())!
    
    public init(_ callback: @escaping (_ wifiEnabled: Bool)->()) {
        self.callback = callback
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(notification:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    public func start() {
        // self.textLabel.text = Translate("PleaseConnectToWifi")
        do{
            try reachability.startNotifier()
        } catch {
            callback(false)
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability

        switch reachability.connection {
        case .wifi:
            self.callback(true)
        default:
            self.callback(false)
        }
    }
}
