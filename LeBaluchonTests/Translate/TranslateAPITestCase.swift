//
//  TranslateAPITestCase.swift
//  LeBaluchonTests
//
//  Created by Alexandre Goncalves on 08/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class TranslateAPITestCase: XCTestCase {

    var text: String!
    var source: String!
    var target: String!
    
    override func setUp() {
        text = "Hello, world"
        source = "en"
        target = "fr"
    }

    /// Test case where there is an error in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfError() {
        // Given
        let translate = TranslateAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseTranslate.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.getTranslation(textToTranslate: text, sourceLanguage: source, targetLanguage: target) { (translate, success) in
            
            // Then
            XCTAssertNil(translate)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    
}
