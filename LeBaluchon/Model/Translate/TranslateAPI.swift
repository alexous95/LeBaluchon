//
//  TranslateAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 06/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class TranslateAPI {
    
    // MARK: - Variables
    
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    
    convenience init(session: URLSession) {
        self.init()
        self.session = session
    }
    
    var tranlateText: String?
    var targetLanguage: String?
    var sourceLanguage: String?
    
    // MARK: - Private
    
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
    /// - This methode takes a closure as parameter to save and transmit an Translate object and a boolean that indicate whether the
    /// query operation was successful or not to the controller
    func getTranslation(textToTranslate: String, sourceLanguage: String, targetLanguage: String, completionHandler: @escaping (Translate?, Bool) -> Void) {
        guard let request = createTranslateRequest(textToTranslate: textToTranslate, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) else {
            completionHandler(nil, false)
            return
        }
        
        let decoder = JSONDecoder()
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let jsonData = data, error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 else {
                    completionHandler(nil, false)
                    return
                }
                do {
                    let decoded = try decoder.decode(Translate.self, from: jsonData)
                    completionHandler(decoded, true)
                } catch {
                    print(error)
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
    
    func getSupportedLanguages(completionHandler: @escaping (SupportedLanguages?, Bool) -> Void) {
        guard let request = createLanguageRequest() else {
            completionHandler(nil, false)
            return
        }
    
        let decoder = JSONDecoder()
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let jsonData = data, error == nil else {
                    completionHandler(nil, false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 else {
                    completionHandler(nil, false)
                    return
                }
                do {
                    let decoded = try decoder.decode(SupportedLanguages.self, from: jsonData)
                    completionHandler(decoded, true)
                } catch {
                    print(error)
                    completionHandler(nil, false)
                }
            }
        }
        task?.resume()
    }
}
