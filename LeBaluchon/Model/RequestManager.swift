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
    
    var request: URLRequest?
    
    // We create variables for the session and datatask to conform the dependance injection pattern for our test
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    convenience init(session: URLSession) {
        self.init()
        self.session = session
    }
    
    func launch(request: URLRequest, api: APIManager, completionHandler: @escaping ((Any?, Bool) -> Void)) {
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            // We use here dispatchQueue.main.async to be sure to go back to the main queue because the user interaction is handled only in the main queue
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
                    debugPrint("failed to decode")
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
}


