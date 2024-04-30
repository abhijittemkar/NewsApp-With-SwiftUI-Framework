import Foundation

struct HourlyForecastResponse: Decodable {
    let hourly: HourlyData
}

struct HourlyData: Decodable {
    let data: [HourlyForecast]

    enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([HourlyForecast].self, forKey: .data)
    }
}

struct HourlyForecast: Identifiable, Decodable {
    let id = UUID()
    let date: String
    let icon: Int
    let temperature: Double

    var formattedDate: String {
        return date.convertToHourFormat() ?? ""
    }
    
    var iconImageName: String {
        return "\(icon)"
    }
}

class HourlyForecastManager {
    static let shared = HourlyForecastManager()
    
    func fetchHourlyForecast(for city: String, completion: @escaping (Result<[HourlyForecast], Error>) -> Void) {
        LocationManager.shared.getCoordinates(for: city) { result in
            switch result {
            case .success(let (latitude, longitude)):
                let url = URL(string: "https://www.meteosource.com/api/v1/free/point?lat=\(latitude)&lon=\(longitude)&sections=current%2Chourly&language=en&units=ca&key=5sqwjkxer8mrm4ij9lskbf58043va8e7p9451a7p")
                
                if let url = url {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else {
                            completion(.failure(error ?? HourlyForecastError.unknownError))
                            return
                        }
                        
                        do {
                            let hourlyForecastData = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
                            completion(.success(hourlyForecastData.hourly.data))
                        } catch {
                            completion(.failure(error))
                        }
                    }.resume()
                } else {
                    completion(.failure(HourlyForecastError.invalidURL))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum HourlyForecastError: Error {
    case invalidURL
    case unknownError
}

extension String {
    func convertToHourFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
