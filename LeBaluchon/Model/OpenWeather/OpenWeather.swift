
import Foundation

// MARK: - OpenWeather

/// The struct used to decode a json response from an OpenWeather request
struct OpenWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let snow: Snow?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int
    let sys: Sys
    let timezone: Date
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds

struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Main

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain

struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Snow

struct Snow: Codable {
    let the1H: Double?
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Sys

struct Sys: Codable {
    let type, id: Int
    let message: Double?
    let country: String
    let sunrise, sunset: Date
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
