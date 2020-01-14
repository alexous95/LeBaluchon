//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 30/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

struct WeatherService {
    
    /// Creates a string to use as an url
    /// - Returns: A String that will be used as an url to get the NY weather
    static func createNYStringRequest() -> String {
        let endpoint = OpenWeatherURL.endpoint
        
        // This constant uses the id parameter for New-York from the openWeather API
        let parametersNY = "?id=5128638&units=metric"
        
        let appID = "&APPID=\(APIKeys.OpenWeatherKey)"
        
        return endpoint + parametersNY + appID
    }
    
    /// Creates a string to use as an url
    /// - Parameter lon: The longitude of the requested location
    /// - Parameter lat: The latitude of the requested location
    /// - Returns: A String that will be used as an url to get the current location weather
    static func createCurrentStringRequest(lon: Double, lat: Double)  -> String {
        let endpoint = OpenWeatherURL.endpoint
        let parameters = "?lat=\(lat)&lon=\(lon)&units=metric"
        let appID = "&APPID=\(APIKeys.OpenWeatherKey)"
        
        return endpoint + parameters + appID
    }
}
