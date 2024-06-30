//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import Foundation

public func GetAppVersion() -> String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

public func GetAppBuildNumber() -> String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
}

public func GetAppDisplayName() -> String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
}
