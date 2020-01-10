//
//  ExchangeAPITestCase.swift
//  LeBaluchonTests
//
//  Created by Alexandre Goncalves on 10/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class ExchangeAPITestCase: XCTestCase {

    override func setUp() {}

    /// Test case where there is an error in getExchange
    func testGivenNilExchange_WhenGettingExchange_ThenCallBackFailIfError() {
        // Given
        let exchange = ExchangeAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseExchange.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        exchange.getExchange { (exchange, success) in
            
            // Then
            XCTAssertNil(exchange)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getExchange
    func testGivennilExchange_WhenGettingExchange_ThenCallbackFailIfNoData() {
        // Given
        let exchange = ExchangeAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        exchange.getExchange { (exchange, success) in
            
            // Then
            XCTAssertNil(exchange)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect url response in getExchange
    func testGivenNilExchange_WhenGettingExchange_ThenCallbackFailIfIncorrectUrlResponse() {
        // Given
        let exchange = ExchangeAPI(session: URLSessionFake(data: FakeResponseExchange.exchangeCorrectData, urlResponse: FakeResponseExchange.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        exchange.getExchange { (exchange, success) in
            
            // Then
            XCTAssertNil(exchange)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilExchange_WhenGettingExchange_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let exchange = ExchangeAPI(session: URLSessionFake(data: FakeResponseExchange.exchangeCorrectData, urlResponse: FakeResponseExchange.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        exchange.getExchange { (exchange, success) in
            
            // Then
            XCTAssertNotNil(exchange)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenNilExchange_WhenGettingExchange_ThenDataEqualsJsonData() {
        // Given
        let exchange = ExchangeAPI(session: URLSessionFake(data: FakeResponseExchange.exchangeCorrectData, urlResponse: FakeResponseExchange.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        exchange.getExchange { (exchange, success) in
            
            // Then
            XCTAssertNotNil(exchange)
            XCTAssertTrue(success)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let successRate = true
            let base = "EUR"
            let date = formatter.date(from: "2020-01-10")
            let rates = ["USD":  1.110692,
                         "JPY": 121.700179,
                         "GBP": 0.850496,
                         "AUD": 1.614906,
                         "CHF": 1.081503
            ]
            
            XCTAssertEqual(successRate, exchange!.success)
            XCTAssertEqual(base, exchange!.base)
            XCTAssertEqual(date, exchange!.date)
            XCTAssertEqual(rates, exchange!.rates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

}
