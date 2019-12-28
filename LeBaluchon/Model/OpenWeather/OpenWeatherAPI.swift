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
    
    private let weatherURL = URL(string: OpenWeatherURL.url)!
    
    private func createWeatherRequest() -> URLRequest {
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        
        return request
    }
    
    func getExchange(completionHandler: @escaping ((OpenWeather?, Bool) -> Void)) {
        
        let request = createWeatherRequest()
        let session = URLSession(configuration: .default)
        
        /// Constant that hold our JSONDecoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
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
}
