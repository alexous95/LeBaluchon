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
    var requestTranslate: URLRequest!
    var requestLanguage: URLRequest!
    
    override func setUp() {
        text = "Hello, world"
        source = "en"
        target = "fr"
        requestTranslate = TranslateAPI().createTranslateRequest(textToTranslate: text, sourceLanguage: source, targetLanguage: target)
        requestLanguage = TranslateAPI().createLanguageRequest()
    }

    // MARK: - Test GetTranslation
    
    /// Test case where there is an error in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfError() {
        // Given
        let translate = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseTranslate.error))
        
        // When
        translate.launch(request: requestTranslate, api: .google) { (data, success) in
             // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
        }
    }
    
    /// Test case where there is no data in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfNoData() {
        // Given
        let translate = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.launch(request: requestTranslate, api: .google) { (data, success) in
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect url response in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfIncorrectUrlResponse() {
        // Given
        let translate = RequestManager(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.launch(request: requestTranslate, api: .google) { (data, success) in
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilTranslate_WhenGettingTranslation_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let translate = RequestManager(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.launch(request: requestTranslate, api: .google) { (data, success) in
            // Then
            XCTAssertNotNil(data)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    /// Test case where there the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilTranslate_WhenGettingTranslation_ThenTranslationEqualsJsonData() {
        // Given
        let translate = RequestManager(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.launch(request: requestTranslate, api: .google) { (data, success) in
            // Then
            XCTAssertNotNil(data)
            XCTAssertTrue(success)
            guard let translation = data as! Translate? else { return }
            
            XCTAssertEqual("Bonjour, monde", translation.data.translations[0].translatedText)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Test GetLanguages
    
    /// Test case where there is an error in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfError() {
        // Given
       let language = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseTranslate.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.launch(request: requestLanguage, api: .language) { (data, success) in
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    /// Test case where there is no data in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfNoData() {
        // Given
        let language = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
    
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.launch(request: requestLanguage, api: .language) { (data, success) in
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect url response in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfIncorrectUrlResponse() {
        // Given
        let language = RequestManager(session: URLSessionFake(data: FakeResponseTranslate.languageCorrectData, urlResponse: FakeResponseTranslate.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.launch(request: requestLanguage, api: .language) { (data, success) in
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilLanguage_WhenGettingLanguage_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let language = RequestManager(session: URLSessionFake(data: FakeResponseTranslate.languageCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.launch(request: requestLanguage, api: .language) { (data, success) in
            // Then
            XCTAssertNotNil(data)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
