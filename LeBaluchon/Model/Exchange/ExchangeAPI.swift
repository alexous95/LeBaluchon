//
//  ExchangeRequest.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class ExchangeAPI {
    
    // MARK: - Variables
    
    /// Hold our URLSessionDataTask avoiding to create a task each time we do a request
    private var task: URLSessionDataTask?
    
    /// Hold our session to start network request
    private var session = URLSession(configuration: .default)
    
    /// Hold the URL of our API
    private let exchangeUrl = URL(string: Fixer.fixerUrl)!
  
    // The convenience init is used for our test class
    convenience init(session: URLSession) {
        self.init()
        self.session = session
    }
    
    // MARK: - Private
    
    /// Create a request from our URL
    /// - Returns: A URLRequest from our Url and set http method to "GET"
    private func createExchangeRequest() -> URLRequest {
        var request = URLRequest(url: exchangeUrl)
        request.httpMethod = "GET"
        
        return request
    }
    
    // MARK: - Functions
    
    /// Request for json file from the API Fixer.IO
    ///
    /// - parameter completionHandler: A closure with the type ( (Exchange?, Bool) -> Void) ) used to pass data to the controller
    ///
    /// - This methode takes a closure as parameter to save and transmit an Exchange object and a boolean that indicate whether the query operation was successful or not to the controller
    func getExchange(completionHandler: @escaping ((Exchange?, Bool) -> Void)) {
        
        let request = createExchangeRequest()
        
        /// Constant that hold our custom formatter that will be used in our JSONDecoder
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        /// Constant that hold our JSONDecoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
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
                    let decoded = try decoder.decode(Exchange.self, from: data)
                    completionHandler(decoded, true)
                } catch {
                    print("failed to decode")
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
}
