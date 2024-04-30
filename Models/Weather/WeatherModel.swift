//
//  WeatherModel.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Алексей Воронов on 21.07.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//


import Foundation


class WeatherManager {
    static let shared = WeatherManager()
    
    func fetchData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        LocationManager.shared.getCoordinates(for: city) { result in
            switch result {
            case .success(let (latitude, longitude)):
                let url = URL(string: "https://www.meteosource.com/api/v1/free/point?lat=\(latitude)&lon=\(longitude)&sections=current%2Chourly&language=en&units=ca&key=5sqwjkxer8mrm4ij9lskbf58043va8e7p9451a7p")
              
                if let url = url {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else {
                            completion(.failure(error ?? WeatherError.unknownError))
                            return
                        }
                        
                        do {
                            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                            completion(.success(weatherData))
                        } catch {
                            completion(.failure(error))
                        }
                    }.resume()
                } else {
                    completion(.failure(WeatherError.invalidURL))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


