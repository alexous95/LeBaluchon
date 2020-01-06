//
//  TranslateAPI.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 06/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

final class TranslateAPI {
    
    private var task: URLSessionDataTask?
    var tranlateText: String?
    var targetLanguage: String?
    var sourceLanguage: String?
    
    private func createRequest(textToTranslate: String, sourceLanguage: String, targetLanguage: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Google.scheme
        urlComponents.host = Google.host
        urlComponents.path = Google.path
        urlComponents.queryItems = [URLQueryItem(name: "key", value: APIKeys.GoogleTranslateKey)]
        
        let headers: [String: String]   = [
            "Content-Type" : "application/json"
        ]
        
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
    
    func getTranslation(textToTranslate: String, sourceLanguage: String, targetLanguage: String, completionHandler: @escaping (Translate?, Bool) -> Void) {
        guard let request = createRequest(textToTranslate: textToTranslate, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) else {
            completionHandler(nil, false)
            return
        }
        let session = URLSession(configuration: .default)
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
}
