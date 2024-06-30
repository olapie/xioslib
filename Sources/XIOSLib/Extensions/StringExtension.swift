//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import Foundation

extension String {
    func compactNewLines() -> String {
        var str = self
        while true {
            let n = str.count
            str = str.replacingOccurrences(of: "\n\n", with: "\n")
            if str.count == n {
                break
            }
        }
        return str
    }
}
