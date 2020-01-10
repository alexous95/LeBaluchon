//
//  OpenWeatherAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 27/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class OpenWeatherAPI {
    
    /// Hold our URLSessionDataTask avoiding to create a task each time we do a request
    private var task: URLSessionDataTask?
    
    /// This is our dependance injection to test our getCurrentWeather methode
    private var currentWeatherSession = URLSession(configuration: .default)
    
    /// This is our dependance injection to test our getNYWeather methode
    private var nyWeatherSession = URLSession(configuration: .default)
    
    /// This is our dependande injection to test our getWeatherIcon methode
    private var iconSession = URLSession(configuration: .default)
    
    init(){}
    
    convenience init(currentWeatherSession: URLSession, nyWeatherSession: URLSession, iconSession: URLSession) {
        self.init()
        self.currentWeatherSession = currentWeatherSession
        self.nyWeatherSession = nyWeatherSession
        self.iconSession = iconSession
    }
    
    /// Create a request from our url
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
    /// - Parameter lon: The longitude of the current position
    /// - Parameter lat: The latitude of the position
    /// - Returns: A URLRequest from our url and set the httpMethod to "GET"
    private func createCurrentWeatherRequest(lon: Double, lat: Double) -> URLRequest {
        guard let currentWeatherUrl = URL(string: WeatherService.createCurrentStringRequest(lon: lon, lat: lat)) else {
            preconditionFailure("Invalid URL request")
        }
        
        var request = URLRequest(url: currentWeatherUrl)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Request for json file from the API OpenWeather
    ///
    /// - Parameter completionHandler: An escaping closure with the type ((OpenWeather?, Bool) -> Void)) used to pass data to the
    /// controller
    /// - Parameter lon: The longitude of the current position
    /// - Parameter lat: The latitude of the current position
    /// - This methode takes a closure as parameter to save and transmit an OpenWeather object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getCurrentWeather(lon: Double, lat: Double, completionHandler: @escaping ((OpenWeather?, Bool) -> Void)){
    
    let request = createCurrentWeatherRequest(lon: lon, lat: lat)
    
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    
    task?.cancel()
    task = currentWeatherSession.dataTask(with: request) { (data, response, error) in
        // We use here dispatchQueue.main.async to be sure to go back to the main queue because the user interaction is handled only in the main queue
        DispatchQueue.main.async {
            guard let jsonData = data, error == nil else {
                completionHandler(nil, false)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil, false)
                return
            }
            do {
                let decoded = try decoder.decode(OpenWeather.self, from: jsonData)
                completionHandler(decoded, true)
            } catch {
                print(error)
                completionHandler(nil, false)
            }
        }
    }
    task?.resume()
}
    
    /// Create a request from our url
    /// - Parameter identifier: A string from our model which hold the last part our request
    /// - The url is the concatenation of our imgAdress from OpenWeatherURL struct, the icon identifier and the format
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
    
    /// Request for json file from the API OpenWeather
    ///
    /// - parameter completionHandler: An escaping closure with the type ((OpenWeather?, Bool) -> Void)) used to pass data to the
    /// controller
    ///
    /// - This methode takes a closure as parameter to save and transmit an OpenWeather object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getNYWeather(completionHandler: @escaping ((OpenWeather?, Bool) -> Void)) {
        
        let request = createNYWeatherRequest()
        
        /// Constant that hold our JSONDecoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        task?.cancel()
        task = nyWeatherSession.dataTask(with: request) { (data, response, error) in
            // We use here dispatchQueue.main.async to be sure to go back to the main queue because the user interaction is handled only in the main queue
            DispatchQueue.main.async {
                guard let jsonData = data, error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil, false)
                    return
                }
                do {
                    let decoded = try decoder.decode(OpenWeather.self, from: jsonData)
                    completionHandler(decoded, true)
                } catch {
                    print(error)
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
    
    /// Request for an icon from the API OpenWeather
    ///
    /// - parameter completionHandler: An escaping closure with the type ((Data?, Bool) -> Void)) used to pass data to the
    /// controller
    /// - parameter identifier: A string from our model which represents our icon
    /// - This methode takes a closure as parameter to save and transmit an Data object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getWeatherIcon(identifier: String, completionHandler: @escaping ((Data?, Bool) -> Void)) {
        let request = createIconRequest(with: identifier)
        
        task?.cancel()
        task = iconSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let imgData = data, error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil, false)
                    return
                }
                completionHandler(imgData, true)
            }
        }
        task?.resume()
    }
}
