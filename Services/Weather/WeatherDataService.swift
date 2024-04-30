//  WeatherDataService.swift



import Foundation


class WeatherDataService {
    static let shared = WeatherDataService()
    
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        WeatherManager.shared.fetchData(for: city) { result in
            switch result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchHourlyData(for city: String, completion: @escaping (Result<[HourlyForecast], Error>) -> Void) {
        HourlyForecastManager.shared.fetchHourlyForecast(for: city) { result in
            switch result {
            case .success(let hourlyData):
                completion(.success(hourlyData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


struct WeatherData: Decodable {
    let current: CurrentWeather
    let timezone: String
}

struct CurrentWeather: Decodable {
    let icon: String
    let icon_num: Int
    let summary: String
    let temperature: Double
    let wind: Wind
    let precipitation: Precipitation
    let cloud_cover: Int
}


struct Precipitation: Decodable {
    let total: Double
    let type: String
}

struct Wind: Decodable {
    let speed: Double
    let angle: Int
    let dir: String
}

enum WeatherError: Error {
    case invalidURL
    case unknownError
}
