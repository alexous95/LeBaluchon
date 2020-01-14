//
//  Translate.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 06/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

/// The struct to decode a json response from the google translation request
struct Translate: Codable {
    let data: Translation
    
    struct Translation: Codable {
        var translations: [TranslatedText]
        
        struct TranslatedText: Codable {
            var translatedText: String
        }
    }
}

/// The struct to decode a json response from the google language request
struct SupportedLanguages: Codable {
    let data: LanguageSupportedList
    
    struct LanguageSupportedList: Codable {
        var languages: [SupportedLanguagesResponse]
        
        struct SupportedLanguagesResponse: Codable {
            var language: String
            var name: String
        }
    }
}
