//
//  URL.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 18/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

// Struct that holds our adresses to create url from the fixer API
struct Fixer {
    
    /// This constant represents our endpoint acces to the API
    static private let endPoint = "http://data.fixer.io/api/latest"
    
    /// This constant represents our access key to use the API
    static private let accessKey = "?access_key=\(APIKeys.FixerKey)"
    
    /// This constant represents our parameters for our query
    static private let parameters = "&symbols=USD,JPY,GBP,AUD,CHF,EUR"
    
    /// The complete URL for accessing data
    ///
    /// - Returns: - The URL to access our data
    static var fixerUrl : String {
        return endPoint + accessKey + parameters
    }
    
}

// Struct that holds our adresses to create url from the OpenWeather API
struct OpenWeatherURL {
   
    static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
    static let imgAdress = "http://openweathermap.org/img/wn/"
    
}

// Struct that holds our adresses to create url from the Google translate API
struct Google {
    static let scheme = "https"
    static let host = "translation.googleapis.com"
    static let path = "/language/translate/v2"
    static let languageEndpoint = "/languages"
}

