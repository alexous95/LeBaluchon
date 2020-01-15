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
    
    /// Hold the URL of our API
    private let exchangeUrl = URL(string: Fixer.fixerUrl)!
    
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
    func getExchange(completionHandler: @escaping (Exchange?, Bool) -> Void) {
        let request = createExchangeRequest()
        
        RequestManager().launch(request: request, api: .fixer) { (data, success) in
            if success {
                guard let exchange = data as! Exchange? else { return }
                completionHandler(exchange, success)
            }
            else {
                print("Ca marche pas c'est nul")
            }
        }
    }
}
