//
//  WeatherManager.swift
//  Clima
//
//  Created by Sayed Mobin Sadat on 7/21/20.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3cf80b815e62dab5f5dea52c5447c550&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
           let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
           performRequest(with: urlString)
           
       }
    
    func performRequest(with urlString: String) {
        // 1. create a URL
        if let url = URL(string: urlString) {
            
            // 2. create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            // let dataString = String(data: safeData, encoding: .utf8)
            // 4. start a task
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
       let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, latitude: lat, longitude: lon)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
        
}
