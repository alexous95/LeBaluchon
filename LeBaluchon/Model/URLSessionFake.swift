//
//  URLSessionFake.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 08/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

/// This class is used to test code in the test target.
/// We use the fake model to test our network calls
class URLSessionFake: URLSession {
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = urlResponse
        task.responseError = responseError
        return task
    }
}

/// This class is used to test code in the test Target.
class URLSessionDataTaskFake: URLSessionDataTask {
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
}
