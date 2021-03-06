//
//  WeatherData.swift
//  Clima
//
//  Created by Sayed Mobin Sadat on 7/21/20.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
}

struct Main: Codable {
    let temp: Float
}

struct Weather: Codable {
    
    let id: Int
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}



