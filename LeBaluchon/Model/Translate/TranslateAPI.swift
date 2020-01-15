//
//  TranslateAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 06/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class TranslateAPI {
    
    // MARK: - Private
    
    /// Creates a request from the parameters passed to the function
    ///
    /// - Parameter textToTranslate: A string that hold the text to translate
    /// - Parameter sourceLanguage: A string that hold the source language of the the text we want to translate
    /// - Parameter targetLanguage: A string that hold the target language of the the text we want to translate
    ///
    /// - Returns: An URLRequest configured with the content type header for json file and a body created by the JsonSerialization of the parameters passed to the function
    private func createTranslateRequest(textToTranslate: String, sourceLanguage: String, targetLanguage: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Google.scheme
        urlComponents.host = Google.host
        urlComponents.path = Google.path
        urlComponents.queryItems = [URLQueryItem(name: "key", value: APIKeys.GoogleTranslateKey)]
        
        // This is the header we use to specify our data format
        let headers: [String: String] = [
            "Content-Type" : "application/json"
        ]
        
        // This our parameters required by the goolge API
        let parameters = ["q": textToTranslate,
                          "target": targetLanguage,
                          "source": sourceLanguage,
                          "format": "text"]
        
        do {
            let body = try JSONSerialization.data(withJSONObject: parameters)
            let url = urlComponents.url ?? URL(fileURLWithPath: "")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            
            for(headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
            return request
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Request for the language list from the google servers
    ///
    /// - Returns: An URLRequest with the parameters to get the language list
    private func createLanguageRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Google.scheme
        urlComponents.host = Google.host
        urlComponents.path = Google.path + Google.languageEndpoint
        urlComponents.queryItems = [URLQueryItem(name: "key", value: APIKeys.GoogleTranslateKey)]
        
        let headers: [String:String] = ["Content-Type": "application/json"]
        
        let parameters = [ "target": "en",
                           "model": "base",
        ]
        
        do {
            let body = try JSONSerialization.data(withJSONObject: parameters)
            let url = urlComponents.url ?? URL(fileURLWithPath: "")
            
            var request = URLRequest(url: url)
            
            // Using a GET request with a body is impossible since ios 13 so the http methode is replaced by a post
            request.httpMethod = "POST"
            request.httpBody = body
            
            for(headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
            return request
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Functions
    
    /// Request for json file from the API Google Cloud Translate
    ///
    /// - Parameter completionHandler: An escaping closure with the type ((Translate?, Bool) -> Void)) used to pass data to the
    /// controller
    /// - Parameter textToTranslate: The text we want to translate
    /// - Parameter sourceLanguage: The language of the text we want to translate
    /// - Parameter targetLanguage: The language that our text will be translated to
    ///
    /// - This methode takes a closure as parameter to save and transmit an Translate object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getTranslation(textToTranslate: String, sourceLanguage: String, targetLanguage: String, completionHandler: @escaping (Translate?, Bool) -> Void) {
        guard let request = createTranslateRequest(textToTranslate: textToTranslate, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) else {
            completionHandler(nil, false)
            return
        }
        
        RequestManager().launch(request: request, api: .google) { (data, success) in
            if success {
                guard let translate = data as! Translate? else { return }
                completionHandler(translate, success)
            }
            else {
                debugPrint("Ca marche pas c'est nul")
            }
        }
    }
    
    /// Request for json file from the API Google Cloud Translate
    ///
    /// - Parameter completionHandler: An escaping closure with the type ((SupportedLanguages?, Bool) -> Void)) used to pass data to the
    /// controller
    /// 
    /// - This methode takes a closure as parameter to save and transmit an SupportedLanguages object and a boolean that indicate whether
    ///the query operation was successful or not to the controller
    func getSupportedLanguages(completionHandler: @escaping (SupportedLanguages?, Bool) -> Void) {
        guard let request = createLanguageRequest() else {
            completionHandler(nil, false)
            return
        }
    
        RequestManager().launch(request: request, api: .language) { (data, success) in
            if success {
                guard let languages = data as! SupportedLanguages? else { return }
                completionHandler(languages, success)
            }
            else {
                debugPrint("Ca marche pas c'est nul")
            }
        }
}
}
