//
//  OpenWeatherAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 27/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class OpenWeatherAPI {
    
    // MARK: - Private
    
    /// Create a request from our url
    ///
    /// - Returns: A URLRequest from our url and set the httpMethod to "GET"
    private func createNYWeatherRequest() -> URLRequest {
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
    private func createCurrentWeatherRequest(lon: Double, lat: Double) -> URLRequest {
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
    private func createIconRequest(with identifier: String) -> URLRequest {
        let image = OpenWeatherURL.imgAdress + identifier + "@2x.png"
        guard let imageUrl = URL(string: image) else {
            preconditionFailure("Invalid request URL")
        }
        var request = URLRequest(url: imageUrl)
        request.httpMethod = "GET"
        
        return request
    }
    
    // MARK: - Functions
    
    /// Request for json file from the API OpenWeather
    ///
    /// - Parameter completionHandler: An escaping closure with the type ((OpenWeather?, Bool) -> Void)) used to pass data to the
    /// controller
    /// - Parameter lon: The longitude of the current position
    /// - Parameter lat: The latitude of the current position
    ///
    /// - This methode takes a closure as parameter to save and transmit an OpenWeather object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getCurrentWeather(lon: Double, lat: Double, completionHandler: @escaping ((OpenWeather?, Bool) -> Void)){
        let request = createCurrentWeatherRequest(lon: lon, lat: lat)
        
        RequestManager().launch(request: request, api: .openWeather) { (data, success) in
            if success {
                guard let currentWeather = data as! OpenWeather? else { return }
                completionHandler(currentWeather, success)
            }
            else {
                print("Ca marche pas c'est nul")
            }
        }
    }
    
    /// Request for json file from the API OpenWeather
    ///
    /// - parameter completionHandler: An escaping closure with the type ((OpenWeather?, Bool) -> Void)) used to pass data to the
    /// controller
    ///
    /// - This methode takes a closure as parameter to save and transmit an OpenWeather object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getNYWeather(completionHandler: @escaping ((OpenWeather?, Bool) -> Void)) {
        let request = createNYWeatherRequest()
        
        RequestManager().launch(request: request, api: .openWeather) { (data, success) in
            if success {
                guard let nyWeather = data as! OpenWeather? else { return }
                completionHandler(nyWeather, success)
            }
            else {
                print("Ca marche pas c'est nul")
            }
        }
    }
    
    /// Request for an icon from the API OpenWeather
    ///
    /// - parameter completionHandler: An escaping closure with the type ((Data?, Bool) -> Void)) used to pass data to the
    /// controller
    /// - parameter identifier: A string from our model which represents our icon
    ///
    /// - This methode takes a closure as parameter to save and transmit a Data object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getWeatherIcon(identifier: String, completionHandler: @escaping ((Data?, Bool) -> Void)) {
        let request = createIconRequest(with: identifier)
        
        RequestManager().launch(request: request, api: .image) { (data, success) in
            if success {
                guard let imgData = data as! Data? else { return }
                completionHandler(imgData, success)
            }
            else {
                print("Ca marche pas c'est nul")
            }
        }
    }
}
