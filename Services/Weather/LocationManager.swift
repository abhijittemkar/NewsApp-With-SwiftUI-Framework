//
//  LocationManager.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 21/03/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//



import Foundation
import CoreLocation


struct LocationManager {
    static let shared = LocationManager() // Singleton instance
    
    private init() {} // Private initializer to prevent multiple instances
    
    func getCoordinates(for city: String?, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        let defaultCity = "Toronto"
        
        guard let city = city, !city.isEmpty else {
            // Return coordinates for the default city if the provided city name is empty
            getCoordinates(for: defaultCity, completion: completion)
            return
        }
        
        let geocoder = CLGeocoder()
        
        // Check if the provided city name is a valid location
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let error = error {
                // If error occurs during geocoding, return failure with the error
                completion(.failure(error))
            } else if let placemark = placemarks?.first {
                // If valid placemark is found, extract coordinates
                if let location = placemark.location {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    completion(.success((latitude, longitude)))
                } else {
                    // If location is not found in placemark, return failure with a custom error
                    completion(.failure(NSError(domain: "LocationManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Location not found"])))
                }
            } else {
                // If no placemark is found, return failure with a custom error
                completion(.failure(NSError(domain: "LocationManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "City not found"])))
            }
        }
    }
    
    func getDeviceLocation(completion: @escaping (Result<String, Error>) -> Void) {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            // If location services are not enabled, return the default city name
            completion(.success("Toronto"))
            return
        }
        
        if let location = locationManager.location {
            // Reverse geocode location to obtain city name
            getCityName(for: location) { result in
                switch result {
                case .success(let city):
                    completion(.success(city))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // If device location cannot be fetched, return the default city name
            completion(.success("Toronto"))
            let error = NSError(domain: "LocationManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch device location"])
                    completion(.failure(error))
        }
    }
    
    // Change the access level to 'internal' to make it accessible outside the module
    func getCityName(for location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    completion(.success(city))
                } else {
                    completion(.failure(NSError(domain: "LocationManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "City name not found"])))
                }
            } else {
                completion(.failure(NSError(domain: "LocationManager", code: 4, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"])))
            }
        }
    }
}
