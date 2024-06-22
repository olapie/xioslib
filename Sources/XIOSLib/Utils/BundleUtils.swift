//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import Foundation

func GetAppVersion() -> String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

func GetAppBuildNumber() -> String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
}

func GetAppDisplayName() -> String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
}
