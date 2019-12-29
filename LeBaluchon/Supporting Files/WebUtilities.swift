//
//  URL.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 18/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

struct Fixer {
    
    /// This constant represents our endpoint acces to the API
    static private let endPoint = "http://data.fixer.io/api/latest"
    
    /// This constant represents our access key to use the API
    static private let accessKey = "?access_key=\(APIKeys.FixerKey)"
    
    /// This constant represents our parameters for our query
    static private let parameters = "&symbols=USD,JPY,GBP,AUD,CHF"
    
    /// The complete URL for accessing data
    ///
    /// - Returns: - The URL to access our data
    static var fixerUrl : String {
        return endPoint + accessKey + parameters
    }
    
}

struct OpenWeatherURL {
    
    static private let endpoint = "https://api.openweathermap.org/data/2.5/weather"
    
    static private let parameters = "?id=6455259&units=metric"
    
    static private let appID = "&APPID=\(APIKeys.OpenWeatherKey)"
    
    static let imgAdress = "http://openweathermap.org/img/wn/"
    
    static var url: String {
        return endpoint + parameters + appID
    }
}
