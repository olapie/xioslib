//
//  File.swift
//  
//
//  Created by tan on 2024-06-22.
//

import Foundation


func GetLocalLanguage() -> String {
    if #available(iOS 16, *) {
        guard let lang = Locale.current.language.languageCode?.identifier else {
            return "en"
        }
        
        guard let script = Locale.current.language.script?.identifier else {
            return lang
        }
        
        if script.isEmpty {
            return lang
        }
        return lang + "-" + script
    } else {
        return Locale.current.languageCode ?? "en"
    }
}
