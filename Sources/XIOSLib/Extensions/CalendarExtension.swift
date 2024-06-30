//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import Foundation

extension Calendar {
    func isDateInNowYear(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        return calendar.component(.year, from: date) == calendar.component(.year, from: now)
    }
}
