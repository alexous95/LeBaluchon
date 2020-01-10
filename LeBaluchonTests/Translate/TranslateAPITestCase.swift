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

    // MARK: - Test GetTranslation
    
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
    
    /// Test case where there is no data in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfNoData() {
        // Given
        let translate = TranslateAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
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
    
    /// Test case where there is an incorrect url response in getTranslation
    func testGivenNilTranslate_WhenGettingTranslation_ThenCallbackFailIfIncorrectUrlResponse() {
        // Given
        let translate = TranslateAPI(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseKO, responseError: nil))
        
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
    
    /// Test case where there the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilTranslate_WhenGettingTranslation_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let translate = TranslateAPI(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.getTranslation(textToTranslate: text, sourceLanguage: source, targetLanguage: target) { (translation, success) in
            // Then
            XCTAssertNotNil(translation)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    /// Test case where there the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilTranslate_WhenGettingTranslation_ThenTranslationEqualsJsonData() {
        // Given
        let translate = TranslateAPI(session: URLSessionFake(data: FakeResponseTranslate.translateCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translate.getTranslation(textToTranslate: text, sourceLanguage: source, targetLanguage: target) { (translation, success) in
            // Then
            XCTAssertNotNil(translation)
            XCTAssertTrue(success)
            
            XCTAssertEqual("Bonjour, monde", translation!.data.translations[0].translatedText)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Test GetLanguages
    
    /// Test case where there is an error in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfError() {
        // Given
        let language = TranslateAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseTranslate.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.getSupportedLanguages { (languages, success) in
            
            // Then
            XCTAssertNil(languages)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    /// Test case where there is no data in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfNoData() {
        // Given
        let language = TranslateAPI(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.getSupportedLanguages { (languages, success) in
            
            // Then
            XCTAssertNil(languages)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect url response in getTranslation
    func testGivenNilLanguage_WhenGettingLanguage_ThenCallbackFailIfIncorrectUrlResponse() {
        // Given
        let language = TranslateAPI(session: URLSessionFake(data: FakeResponseTranslate.languageCorrectData, urlResponse: FakeResponseTranslate.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.getSupportedLanguages { (languages, success) in
            
            // Then
            XCTAssertNil(languages)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where the data is successfuly retrieved and url response is correct in getExchange
    func testGivenNilLanguage_WhenGettingLanguage_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let language = TranslateAPI(session: URLSessionFake(data: FakeResponseTranslate.languageCorrectData, urlResponse: FakeResponseTranslate.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        language.getSupportedLanguages { (languages, success) in
            // Then
            XCTAssertNotNil(languages)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
