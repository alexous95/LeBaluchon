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
   
    // MARK: - Functions
    
    /// Create a request from our URL
    /// - Returns: A URLRequest from our Url and set http method to "GET"
    func createExchangeRequest() -> URLRequest {
        var request = URLRequest(url: exchangeUrl)
        request.httpMethod = "GET"
        
        return request
    }
}
