//
//  File.swift
//  
//
//  Created by tan on 2024-06-30.
//

import Foundation

class DateFormatters {
    static var yyyyMd = DateFormatter()
    static var Md = DateFormatter()
    static var EEE = DateFormatter()
    static var EEEMd = DateFormatter()
    static var yyyyMdhhmma = DateFormatter()
    static var yyyyMdHHmm = DateFormatter()
    static var EEEMdhhmma = DateFormatter()
    static var EEEMdHHmm = DateFormatter()
    static var Mdhhmma = DateFormatter()
    static var MdHHmm = DateFormatter()
    static var hhmma = DateFormatter()
    static var HHmm = DateFormatter()
    static var initOnce: Void = {
        var code = "en"
        if #available(iOS 16, *) {
            code = NSLocale.current.language.languageCode?.identifier ?? "en"
        } else {
            // Fallback on earlier versions
            code = NSLocale.current.languageCode ?? "en"
        }

        yyyyMd.dateFormat = "yyyy-M-d"
        Md.dateFormat = "M-d"
        EEE.dateFormat = "EEE"
        EEEMd.dateFormat = "EEE M-d"
        yyyyMdHHmm.dateFormat = "yyyy-M-d HH:mm"
        EEEMdHHmm.dateFormat = "EEE M-d HH:mm"
        MdHHmm.dateFormat = "M-d HH:mm"
        HHmm.dateFormat = "HH:mm"

        if code == "zh" {
            yyyyMdhhmma.dateFormat = "yyyy-M-d a hh:mm"
            EEEMdhhmma.dateFormat = "EEE M-d a hh:mm"
            Mdhhmma.dateFormat = "M-d a hh:mm"
            hhmma.dateFormat = "a hh:mm"
        } else {
            yyyyMdhhmma.dateFormat = "yyyy-M-d hh:mm a"
            EEEMdhhmma.dateFormat = "EEE M-d hh:mm a"
            Mdhhmma.dateFormat = "M-d hh:mm a"
            hhmma.dateFormat = "hh:mm a"
        }
    }()
}
