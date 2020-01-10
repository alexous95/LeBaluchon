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
    
    override func setUp() {
        lon = 2.2369
        lat = 48.8842
        identifier = "10n"
    }

    // MARK: - New-York Weather Test
    
    /// Test case where there is an error in GetNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfError() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseData.error),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getNYWeather { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfNoData() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getNYWeather { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect incorrect urlResponse and correct data in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenFailCallbackIfIncorrectUrlResponse() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: FakeResponseData.weatherNYCorrectData, urlResponse: FakeResponseData.responseKO, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getNYWeather { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no error and we received the data in getNYWeather
    func testGivenNilWeather_WhenGettingWeather_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: FakeResponseData.weatherNYCorrectData, urlResponse: FakeResponseData.responseOK, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getNYWeather { (weather, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case when there is no error, we received the data and we compare to what we expect in getNYWeather
    func testGivenNilWeather_WhenGettingNYWeather_ThenDataEqualsWeatherDataJson() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: FakeResponseData.weatherNYCorrectData, urlResponse: FakeResponseData.responseOK, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getNYWeather { (weather, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            
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
            
            XCTAssertEqual(coord.lat, weather!.coord.lat)
            XCTAssertEqual(coord.lon, weather!.coord.lon)
            
            XCTAssertEqual(weatherNY[0].id, weather!.weather[0].id)
            XCTAssertEqual(weatherNY[0].main, weather!.weather[0].main)
            XCTAssertEqual(weatherNY[0].weatherDescription, weather!.weather[0].weatherDescription)
            XCTAssertEqual(weatherNY[0].icon, weather!.weather[0].icon)
            
            XCTAssertEqual(base, weather!.base)
            
            XCTAssertEqual(main.temp, weather!.main.temp)
            XCTAssertEqual(main.feelsLike, weather!.main.feelsLike)
            XCTAssertEqual(main.tempMin, weather!.main.tempMin)
            XCTAssertEqual(main.tempMax, weather!.main.tempMax)
            
            XCTAssertEqual(visibility, weather!.visibility)
            
            XCTAssertEqual(wind.speed, weather!.wind.speed)
            XCTAssertEqual(wind.deg, weather!.wind.deg)
            
            XCTAssertEqual(snow.the1H, weather!.snow!.the1H)
            XCTAssertEqual(snow.the3H, weather!.snow!.the3H)
            
            XCTAssertEqual(clouds.all, weather!.clouds!.all)
            
            XCTAssertEqual(dt, weather!.dt)
            
            XCTAssertEqual(sys.type, weather!.sys.type)
            XCTAssertEqual(sys.id, weather!.sys.id)
            XCTAssertEqual(sys.message, weather!.sys.message)
            XCTAssertEqual(sys.country, weather!.sys.country)
            XCTAssertEqual(sys.sunrise, weather!.sys.sunrise)
            XCTAssertEqual(sys.sunset, weather!.sys.sunset)
            
            XCTAssertEqual(timezone, weather!.timezone)
            XCTAssertEqual(id, weather!.id)
            
            XCTAssertEqual(name, weather!.name)
            
            XCTAssertEqual(cod, weather!.cod)
        
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Current Weather Test
    
    /// Test case where there is an error in GetCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfError() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseData.error),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getCurrentWeather(lon: self.lon, lat: self.lat) { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no data in getCurretnWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfNoData() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getCurrentWeather(lon: self.lon, lat: self.lat) { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is an incorrect incorrect urlResponse and correct data in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenFailCallbackIfIncorrectUrlResponse() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: FakeResponseData.weatherCurrentCorrectData, urlResponse: FakeResponseData.responseKO, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getCurrentWeather(lon: self.lon, lat: self.lat) { (weather, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case where there is no error and we received the data in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: FakeResponseData.weatherCurrentCorrectData, urlResponse: FakeResponseData.responseOK, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getCurrentWeather(lon: self.lon, lat: self.lat) { (weather, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    /// Test case when there is no error, we received the data and we compare to what we expect in getCurrentWeather
    func testGivenNilWeather_WhenGettingCurrentWeather_ThenDataEqualsWeatherDataJson() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: FakeResponseData.weatherCurrentCorrectData, urlResponse: FakeResponseData.responseOK, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getCurrentWeather(lon: self.lon, lat: self.lat) { (weather, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            
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
            
            XCTAssertEqual(coord.lat, weather!.coord.lat)
            XCTAssertEqual(coord.lon, weather!.coord.lon)
            
            XCTAssertEqual(weatherCurrent[0].id, weather!.weather[0].id)
            XCTAssertEqual(weatherCurrent[0].main, weather!.weather[0].main)
            XCTAssertEqual(weatherCurrent[0].weatherDescription, weather!.weather[0].weatherDescription)
            XCTAssertEqual(weatherCurrent[0].icon, weather!.weather[0].icon)
            
            XCTAssertEqual(base, weather!.base)
            
            XCTAssertEqual(main.temp, weather!.main.temp)
            XCTAssertEqual(main.feelsLike, weather!.main.feelsLike)
            XCTAssertEqual(main.tempMin, weather!.main.tempMin)
            XCTAssertEqual(main.tempMax, weather!.main.tempMax)
            
            XCTAssertEqual(visibility, weather!.visibility)
            
            XCTAssertEqual(wind.speed, weather!.wind.speed)
            XCTAssertEqual(wind.deg, weather!.wind.deg)
            
            XCTAssertEqual(clouds.all, weather!.clouds!.all)
            
            XCTAssertEqual(dt, weather!.dt)
            
            XCTAssertEqual(sys.type, weather!.sys.type)
            XCTAssertEqual(sys.id, weather!.sys.id)
            XCTAssertEqual(sys.message, weather!.sys.message)
            XCTAssertEqual(sys.country, weather!.sys.country)
            XCTAssertEqual(sys.sunrise, weather!.sys.sunrise)
            XCTAssertEqual(sys.sunset, weather!.sys.sunset)
            
            XCTAssertEqual(timezone, weather!.timezone)
            XCTAssertEqual(id, weather!.id)
            
            XCTAssertEqual(name, weather!.name)
            
            XCTAssertEqual(cod, weather!.cod)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Image Test
    
     /// Test case where there is an error in GetWeatherIcon
    func testGivenNilIcon_WhenGettingIcon_ThenFailCallbackIfError() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getWeatherIcon(identifier: self.identifier) { (data, success) in
            
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
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getWeatherIcon(identifier: self.identifier) { (data, success) in
            
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
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: FakeResponseData.weatherCurrentCorrectData, urlResponse: FakeResponseData.responseKO, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getWeatherIcon(identifier: self.identifier) { (data, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGivenNilIcon_WhenGettingIcon_ThenDataEqualsImg() {
        // Given
        let weather = OpenWeatherAPI(
            currentWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            nyWeatherSession: URLSessionFake(data: nil, urlResponse: nil, responseError: nil),
            iconSession: URLSessionFake(data: FakeResponseData.imgData, urlResponse: FakeResponseData.responseOK, responseError: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weather.getWeatherIcon(identifier: self.identifier) { (data, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            
            let dataFake = "10n".data(using: .utf8)!
            
            XCTAssertEqual(dataFake, data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
