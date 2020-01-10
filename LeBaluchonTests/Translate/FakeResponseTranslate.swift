//
//  FakeResponseTranslate.swift
//  LeBaluchonTests
//
//  Created by Alexandre Goncalves on 10/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

class FakeResponseTranslate {
    
    // MARK: - Error
    
    class TranslateError: Error {}
    static let error = TranslateError()
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    // MARK: - Data
    
    static var translateCorrectData: Data? {
        // This variable is used to retrieve the bundle in which the class we are using is located
        let bundle = Bundle(for: FakeResponseTranslate.self)
        
        // This variable is used to get the url of our test json file
        let url = bundle.url(forResource: "translate", withExtension: "json")!
        
        // We retrieve the data inside the url
        return try! Data(contentsOf: url)
    }
}
