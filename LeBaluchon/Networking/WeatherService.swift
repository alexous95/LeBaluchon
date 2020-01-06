//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 30/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

struct WeatherService {
    
    static func createNYStringRequest() -> String {
        let endpoint = OpenWeatherURL.endpoint
        // This constant uses the id parameter for New-York from the openWeather API
        let parametersNY = "?id=5128638&units=metric"
        
        let appID = "&APPID=\(APIKeys.OpenWeatherKey)"
        
        return endpoint + parametersNY + appID
    }
    
    static func createCurrentStringRequest(lon: Double, lat: Double)  -> String {
        let endpoint = OpenWeatherURL.endpoint
        let parameters = "?lat=\(lat)&lon=\(lon)&units=metric"
        let appID = "&APPID=\(APIKeys.OpenWeatherKey)"
        
        return endpoint + parameters + appID
    }
}
