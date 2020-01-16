//
//  OpenWeatherAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 27/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class OpenWeatherAPI {
    
    // MARK: - Functions
    
    /// Create a request from our url
    ///
    /// - Returns: A URLRequest from our url and set the httpMethod to "GET"
    func createNYWeatherRequest() -> URLRequest {
        guard let weatherNYUrl = URL(string: WeatherService.createNYStringRequest()) else {
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: weatherNYUrl)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Create a request from our url
    ///
    /// - Parameter lon: The longitude of the current position
    /// - Parameter lat: The latitude of the position
    ///
    /// - Returns: A URLRequest from our url and set the httpMethod to "GET"
    func createCurrentWeatherRequest(lon: Double, lat: Double) -> URLRequest {
        guard let currentWeatherUrl = URL(string: WeatherService.createCurrentStringRequest(lon: lon, lat: lat)) else {
            preconditionFailure("Invalid URL request")
        }
        
        var request = URLRequest(url: currentWeatherUrl)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Create a request from our url
    ///
    /// - Parameter identifier: A string from our model which hold the last part our request
    ///
    /// - The url is the concatenation of our imgAdress from OpenWeatherURL struct, the icon identifier and the format
    ///
    /// - Returns: A URLRequest from our URL and set the httpMethod to "GET"
    func createIconRequest(with identifier: String) -> URLRequest {
        let image = OpenWeatherURL.imgAdress + identifier + "@2x.png"
        guard let imageUrl = URL(string: image) else {
            preconditionFailure("Invalid request URL")
        }
        var request = URLRequest(url: imageUrl)
        request.httpMethod = "GET"
        
        return request
    }
}
