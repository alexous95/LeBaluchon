//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Alexandre Goncalves on 08/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

// This class is used to simulate a response from a network call
class FakeResponseWeather {
    
    // MARK: - Error
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    // MARK: - Data
    
    static var weatherNYCorrectData: Data? {
        // This variable is used to retrieve the bundle in which the class we are using is located
        let bundle = Bundle(for: FakeResponseWeather.self)
        
        // This variable is used to get the url of our test json file
        let url = bundle.url(forResource: "WeatherNY", withExtension: "json")!
        
        // We retrieve the data inside the url
        return try! Data(contentsOf: url)
    }
    
    static var weatherCurrentCorrectData: Data? {
        // This variable is used to retrieve the bundle in which the class we are using is located
        let bundle = Bundle(for: FakeResponseWeather.self)
        
        // This variable is used to get the url of our test json file
        let url = bundle.url(forResource: "WeatherCurrent", withExtension: "json")!
        
        // We retrieve the data inside the url
        return try! Data(contentsOf: url)
    }

    static var weatherIncorrectData = "erreur".data(using: .utf8)!
    
    static let imgData = "10n".data(using: .utf8)
}
