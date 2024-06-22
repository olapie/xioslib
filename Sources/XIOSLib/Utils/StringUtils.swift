//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import Foundation

func Translate(_ key: String) -> String {
    let s = NSLocalizedString(key, comment: "")
//    assert(!s.elementsEqual(key), "Missing " + key)
    return s
}
