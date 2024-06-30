//
//  File.swift
//  
//
//  Created by tan on 2024-06-29.
//

import Foundation

extension Date {
    func isInNowYear() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        return calendar.component(.year, from: self) == calendar.component(.year, from: now)
    }

    func isInNowWeek() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        return isInNowYear() && calendar.component(.weekOfYear, from: self) == calendar.component(.weekOfYear, from: now)
    }

    func isToday() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        return calendar.isDate(self, inSameDayAs: now)
    }

    func isYesterday() -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
    }

    func stringForChat() -> String {
        if isToday() {
            return DateFormatters.hhmma.string(from: self)
        }

        if isYesterday() {
            return Translate("Yesterday")
        }

        if isInNowWeek() {
            return DateFormatters.EEE.string(from: self)
        }

        if isInNowYear() {
            return DateFormatters.Md.string(from: self)
        }
        return DateFormatters.yyyyMd.string(from: self)
    }
    
    func stringForPhoto() -> String {
        if isToday() {
            return DateFormatters.hhmma.string(from: self)
        }

        if isInNowYear() {
            return DateFormatters.Mdhhmma.string(from: self)
        }
        return DateFormatters.yyyyMdhhmma.string(from: self)
    }

    func stringForMsg() -> String {
        if isToday() {
            return DateFormatters.hhmma.string(from: self)
        }

        if isYesterday() {
            return Translate("Yesterday") + " " + DateFormatters.hhmma.string(from: self)
        }

        if isInNowWeek() {
            return DateFormatters.EEEMdhhmma.string(from: self)
        }

        if isInNowYear() {
            return DateFormatters.Mdhhmma.string(from: self)
        }
        return DateFormatters.yyyyMdhhmma.string(from: self)
    }

    func stringForPost() -> String {
        let duration = Date().unixSeconds - Int64(timeIntervalSince1970)
        if duration < Duration.minute {
            return Translate("Now")
        } else if duration < Duration.hour {
            return "\(duration / Duration.minute)\(Translate("m"))"
        } else if duration < Duration.day {
            return "\(duration / Duration.hour)\(Translate("h"))"
        } else if duration < 30 * Duration.day {
            return "\(duration / Duration.day)\(Translate("d"))"
        }
        return DateFormatters.yyyyMd.string(from: self)
    }

    func stringForPostContent() -> String {
        return stringForMsg()
    }

    func stringForAttendee() -> String {
        return stringForMsg()
    }

    func stringForFriendRequest() -> String {
        return stringForMsg()
    }

    func stringForNotice() -> String {
        return stringForMsg()
    }

    func yyyyMd() -> String {
        return DateFormatters.yyyyMd.string(from: self)
    }

    static func from(_ timeIntervalSince1970: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
    }
    
    var unixSeconds: Int64 {
        return Int64(timeIntervalSince1970)
    }
}

