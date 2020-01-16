//
//  OpenWeatherAPITestCase.swift
//  LeBaluchonTests
//
//  Created by Alexandre Goncalves on 08/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class OpenWeatherAPITestCase: XCTestCase {

    // Represent the Geocoordinate of my city for the test
    var lon: Double!
    var lat: Double!
    var identifier: String!
    var requestNy: URLRequest!
    var requestCurrent: URLRequest!
    var requestIcon: URLRequest!
    
    override func setUp() {
        lon = 2.2369
        lat = 48.8842
        identifier = "10n"
        requestNy = OpenWeatherAPI().createNYWeatherRequest()
        requestCurrent = OpenWeatherAPI().createCurrentWeatherRequest(lon: lon, lat: lat)
        requestIcon = OpenWeatherAPI().createIconRequest(with: identifier)
    }

    // MARK: - New-York Weather Test
    
    /// Test case where there is an error in GetNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfError() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseWeather.error) )
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestNy, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfNoData() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestNy, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect incorrect urlResponse and correct data in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfIncorrectUrlResponse() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherNYCorrectData, urlResponse: FakeResponseWeather.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestNy, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no error and we received the data in getNYWeather
    func testGivenNilWeather_WhenGettingWeather_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherNYCorrectData, urlResponse: FakeResponseWeather.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestNy, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNotNil(data)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case when there is no error, we received the data and we compare to what we expect in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenDataEqualsWeatherDataJson() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherNYCorrectData, urlResponse: FakeResponseWeather.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestNy, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            let weatherData = data as! OpenWeather?
            
            let coord = Coord(lon: -75.5, lat: 43)
            var weatherNY = [Weather]()
            weatherNY.append(Weather(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10n"))
            
            let base = "stations"
            let main = Main(temp: 272.18, feelsLike: 268.24, tempMin: 270.37, tempMax: 274.26, pressure: 1009, humidity: 100, seaLevel: nil, grndLevel: nil)
            
            let visibility = 12874
            let wind = Wind(speed: 2.6, deg: 360)
            let snow = Snow(the1H: 0.25, the3H: nil)
            let clouds = Clouds(all: 90)
            let dt = 1578477260
            let sys = Sys(type: 1, id: 5681, message: nil, country: "US", sunrise: Date(timeIntervalSince1970: 1578486773), sunset: Date(timeIntervalSince1970: 1578519824))
            let timezone = Date(timeIntervalSince1970: -18000)
            let id = 5128638
            let name = "New York"
            let cod = 200
            
            XCTAssertEqual(coord.lat, weatherData!.coord.lat)
            XCTAssertEqual(coord.lon, weatherData!.coord.lon)
            
            XCTAssertEqual(weatherNY[0].id, weatherData!.weather[0].id)
            XCTAssertEqual(weatherNY[0].main, weatherData!.weather[0].main)
            XCTAssertEqual(weatherNY[0].weatherDescription, weatherData!.weather[0].weatherDescription)
            XCTAssertEqual(weatherNY[0].icon, weatherData!.weather[0].icon)
            
            XCTAssertEqual(base, weatherData!.base)
            
            XCTAssertEqual(main.temp, weatherData!.main.temp)
            XCTAssertEqual(main.feelsLike, weatherData!.main.feelsLike)
            XCTAssertEqual(main.tempMin, weatherData!.main.tempMin)
            XCTAssertEqual(main.tempMax, weatherData!.main.tempMax)
            
            XCTAssertEqual(visibility, weatherData!.visibility)
            
            XCTAssertEqual(wind.speed, weatherData!.wind.speed)
            XCTAssertEqual(wind.deg, weatherData!.wind.deg)
            
            XCTAssertEqual(snow.the1H, weatherData!.snow!.the1H)
            XCTAssertEqual(snow.the3H, weatherData!.snow!.the3H)
            
            XCTAssertEqual(clouds.all, weatherData!.clouds!.all)
            
            XCTAssertEqual(dt, weatherData!.dt)
            
            XCTAssertEqual(sys.type, weatherData!.sys.type)
            XCTAssertEqual(sys.id, weatherData!.sys.id)
            XCTAssertEqual(sys.message, weatherData!.sys.message)
            XCTAssertEqual(sys.country, weatherData!.sys.country)
            XCTAssertEqual(sys.sunrise, weatherData!.sys.sunrise)
            XCTAssertEqual(sys.sunset, weatherData!.sys.sunset)
            
            XCTAssertEqual(timezone, weatherData!.timezone)
            XCTAssertEqual(id, weatherData!.id)
            
            XCTAssertEqual(name, weatherData!.name)
            
            XCTAssertEqual(cod, weatherData!.cod)
        
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Current Weather Test
    
    /// Test case where there is an error in GetCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfError() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseWeather.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestCurrent, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getCurretnWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfNoData() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestCurrent, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect incorrect urlResponse and correct data in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfIncorrectUrlResponse() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherCurrentCorrectData, urlResponse: FakeResponseWeather.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestCurrent, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertNil(data)
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no error and we received the data in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherCurrentCorrectData, urlResponse: FakeResponseWeather.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestCurrent, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case when there is no error, we received the data and we compare to what we expect in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenDataEqualsWeatherDataJson() {
        // Given
        let weather = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherCurrentCorrectData, urlResponse: FakeResponseWeather.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.launch(request: requestCurrent, api: .openWeather) { (data, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            let weatherData = data as! OpenWeather?
            
            let coord = Coord(lon: 2.24, lat: 48.88)
            var weatherCurrent = [Weather]()
            weatherCurrent.append(Weather(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d"))
            
            let base = "stations"
            let main = Main(temp: 284.92, feelsLike: 281.16, tempMin: 283.71, tempMax: 286.15, pressure: 1013, humidity: 93, seaLevel: nil, grndLevel: nil)
            
            let visibility = 10000
            let wind = Wind(speed: 5.7, deg: 200)
            let clouds = Clouds(all: 90)
            let dt = 1578578225
            let sys = Sys(type: 1, id: 6550, message: nil, country: "FR", sunrise: Date(timeIntervalSince1970: 1578555774), sunset: Date(timeIntervalSince1970: 1578586347))
            let timezone = Date(timeIntervalSince1970: 3600)
            let id = 2985034
            let name = "Puteaux"
            let cod = 200
            
            XCTAssertEqual(coord.lat, weatherData!.coord.lat)
            XCTAssertEqual(coord.lon, weatherData!.coord.lon)
            
            XCTAssertEqual(weatherCurrent[0].id, weatherData!.weather[0].id)
            XCTAssertEqual(weatherCurrent[0].main, weatherData!.weather[0].main)
            XCTAssertEqual(weatherCurrent[0].weatherDescription, weatherData!.weather[0].weatherDescription)
            XCTAssertEqual(weatherCurrent[0].icon, weatherData!.weather[0].icon)
            
            XCTAssertEqual(base, weatherData!.base)
            
            XCTAssertEqual(main.temp, weatherData!.main.temp)
            XCTAssertEqual(main.feelsLike, weatherData!.main.feelsLike)
            XCTAssertEqual(main.tempMin, weatherData!.main.tempMin)
            XCTAssertEqual(main.tempMax, weatherData!.main.tempMax)
            
            XCTAssertEqual(visibility, weatherData!.visibility)
            
            XCTAssertEqual(wind.speed, weatherData!.wind.speed)
            XCTAssertEqual(wind.deg, weatherData!.wind.deg)
            
            XCTAssertEqual(clouds.all, weatherData!.clouds!.all)
            
            XCTAssertEqual(dt, weatherData!.dt)
            
            XCTAssertEqual(sys.type, weatherData!.sys.type)
            XCTAssertEqual(sys.id, weatherData!.sys.id)
            XCTAssertEqual(sys.message, weatherData!.sys.message)
            XCTAssertEqual(sys.country, weatherData!.sys.country)
            XCTAssertEqual(sys.sunrise, weatherData!.sys.sunrise)
            XCTAssertEqual(sys.sunset, weatherData!.sys.sunset)
            
            XCTAssertEqual(timezone, weatherData!.timezone)
            XCTAssertEqual(id, weatherData!.id)
            
            XCTAssertEqual(name, weatherData!.name)
            
            XCTAssertEqual(cod, weatherData!.cod)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Image Test
    
     /// Test case where there is an error in GetWeatherIcon
    func testGivenNilIcon_WhenGettingIcon_ThenFailCallbackIfError() {
        // Given
        let image = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseWeather.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        image.launch(request: requestIcon, api: .image) { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getWeatherIcon
    func testGivenNilIcon_WhenGettingIcon_ThenFailCallbackIfNoData() {
        // Given
        let image = RequestManager(session: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        image.launch(request: requestIcon, api: .image) { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect incorrect urlResponse and correct data in getWeatherIcon
    func testGivenNilIcon_WhenGettingIcon_ThenFailCallbackIfIncorrectUrlResponse() {
        // Given
        let image = RequestManager(session: URLSessionFake(data: FakeResponseWeather.weatherCurrentCorrectData, urlResponse: FakeResponseWeather.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        image.launch(request: requestIcon, api: .image) { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenNilIcon_WhenGettingIcon_ThenDataEqualsImg() {
        // Given
        let image = RequestManager(session: URLSessionFake(data: FakeResponseWeather.imgData, urlResponse: FakeResponseWeather.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        image.launch(request: requestIcon, api: .image) { (data, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            
            let data = data as! Data?
            let dataFake = "10n".data(using: .utf8)!
            
            XCTAssertEqual(dataFake, data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
