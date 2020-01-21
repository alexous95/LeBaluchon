//
//  RequestManager.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 15/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

enum APIManager {
    case google
    case openWeather
    case fixer
    case language
    case image
}

class RequestManager {
    
    // We create variables for the session and datatask to conform the dependance injection pattern for our test
    private var task: URLSessionDataTask?

    // For testing purpose
    private var session = URLSession(configuration: .default)
    convenience init(session: URLSession) {
        self.init()
        self.session = session
    }
    
    /// Request for json file from the API passed as a parameter
    ///
    /// - Parameter request: A URLRequest that will be used with our session
    /// - Parameter api: The api we want to use to handle the result from the request
    /// - parameter completionHandler: A closure with the type ( (Any?, Bool) -> Void) ) used to pass data to the controller
    ///
    /// - This methode takes a closure as parameter to save and transmit an object of type Any? and a boolean that indicate whether the query operation was successful or not to the controller
    func launch(request: URLRequest, api: APIManager, completionHandler: @escaping ((Any?, Bool) -> Void)) {
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil, false)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    switch api {
                    case .google:
                        let decoded = try decoder.decode(Translate.self, from: data)
                        completionHandler(decoded, true)

                    case .openWeather:
                        decoder.dateDecodingStrategy = .secondsSince1970
                        
                        let decoded = try decoder.decode(OpenWeather.self, from: data)
                        completionHandler(decoded, true)
                        
                    case .fixer:
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        decoder.dateDecodingStrategy = .formatted(formatter)
                        
                        let decoded = try decoder.decode(Exchange.self, from: data)
                        completionHandler(decoded, true)
                        
                    case .language:
                        let decoded = try decoder.decode(SupportedLanguages.self, from: data)
                        completionHandler(decoded, true)
                        
                    case .image:
                        completionHandler(data, true)
                    }
                } catch {
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
}


