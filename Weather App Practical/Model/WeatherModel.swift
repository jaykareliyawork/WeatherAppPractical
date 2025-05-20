//
//  WeatherModel.swift
//  Weather App Practical
//
//  Created by Jay's work on 19/05/25.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [WeatherModel]?
    let main: MainModel?
    let wind: WindModel?
    let name: String?
    let coord: CoordinationModel?
    let sys: SysModel?
}

struct WeatherModel: Codable {
    let main: String?
    let weatherDescription: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
}

struct MainModel: Codable {
    let temp: Double?
    let humidity: Int?
    let pressure: Int?
}

struct WindModel: Codable {
    let speed: Double?
}

struct CoordinationModel: Codable {
    let lon: Double?
    let lat: Double?
}

struct SysModel: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
