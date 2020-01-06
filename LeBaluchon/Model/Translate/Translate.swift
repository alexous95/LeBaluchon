//
//  Translate.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 06/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

struct Translate: Codable {
    let data: Translation
    
    struct Translation: Codable {
        var translations: [TranslatedText]
        
        struct TranslatedText: Codable {
            var translatedText: String
        }
    }
}
