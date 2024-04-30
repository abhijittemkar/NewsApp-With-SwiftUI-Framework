//
//  WeatherView.swift
//  weatherApp
//
//  Created by Abhijit Temkar on 20/03/24.
//


import Foundation
import SwiftUI
import UIKit


struct WeatherView: View {
    @State private var cityName: String = "" // City name obtained from device location
  //  @State var cityName: String = "Toronto" // Default city name
    @State private var temperature: Int = 0 // Default temperature
    @State private var summary: String = "" // Default summary
    @State private var icon: String = "" // Default icon
    @State private var icon_num: Int = 1 // Default icon number
    @State private var windSpeed: Double = 0 // Default wind speed
    @State private var windAngle: Int = 0 // Default wind angle
    @State private var precipitationType: String = "" // Default precipitation type
    @State private var cloudCover: Int = 0 // Default cloud cover percentage
    @State var isEditingCity: Bool = false // Track whether the city name is being edited
    @State private var precipitationTotal: Double = 0 // Default precipitation total
    @State private var currentTime: String = "" // Initial value
    @State private var isKeyboardVisible = false
    @State private var topPadding: CGFloat = 0
    @State var hourlyData: [HourlyForecast] = [] // Hourly forecast data
    @State private var errorMessage: String? // Error message to display to the user
    @State private var errorMessage2: String? // Error message to display to the user
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        ZStack {
            // Background image based on icon_num
            Image("New Folder/\(icon_num)bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.7)
            
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(spacing: 0) {
                        HStack {
                            if isEditingCity {
                                TextField("Enter City Name", text: $cityName, onCommit: {
                                    if cityName.isEmpty {
                                        fetchDeviceLocation()
                                    } else {
                                        fetchData(for: cityName)
                                    }
                                    isEditingCity = false
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                                .onAppear {
                                    withAnimation {
                                        scrollView.scrollTo(0, anchor: .top)
                                    }
                                }
                                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                                    let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                                    let keyboardHeight = keyboardFrame.height
                                    let safeAreaInsetsTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
                                    let padding = max(0, keyboardHeight - safeAreaInsetsTop)
                                    withAnimation {
                                        scrollView.scrollTo(0, anchor: .top)
                                        isKeyboardVisible = true
                                        topPadding = padding
                                    }
                                }
                                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                    withAnimation {
                                        isKeyboardVisible = false
                                        topPadding = 0
                                    }
                                }
                            } else {
                                Text(cityName.isEmpty ? "Toronto" : cityName)
                                    .font(.title)
                                    .padding()
                            }
                            
                            Button(action: {
                                isEditingCity.toggle()
                            }) {
                                Image(systemName: "pencil")
                                    .font(.title)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }
                        }
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        if let errorMessage = errorMessage2 {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        HStack {
                            Text("\(temperature)")
                                .font(.system(size: 70)) // Adjust the size to your preference
                            Text("°C")
                                .font(.title)
                        }
                        
                        
                        Image("\(icon_num)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        
                        Text(summary)
                            .font(.headline)
                        
                        // Display the current time here
                        Text(currentTime)
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        HourlyForecastListView(hourlyData: $hourlyData)
                            .padding()
                        
                        LazyVGrid(columns: [GridItem(.fixed(180)), GridItem(.fixed(180))], spacing: 20) {
                            VStack {
                                Text("Precipitation")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(precipitationType)
                                    .foregroundColor(.white)
                                
                                Text(String(format: "%.1f mm", precipitationTotal))
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("Cloud Cover")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("\(cloudCover)%")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("Wind")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                WindView(angle: Int(Double(self.windAngle)), speed: String(format: "%.2f", self.windSpeed))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("Feels Like")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("Upgrade API to view data")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("AQI")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("Upgrade API to view data")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("Visibility")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("Upgrade API to view data")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: 170, height: 170)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)}                    }
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top) // Adjust top padding
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 10) + 60) // Adjust bottom padding with additional space
                    .padding(.bottom, isKeyboardVisible ? 300 : 0) // Adjust bottom padding when keyboard is visible
                    .padding(.top, topPadding) // Adjust top padding to accommodate keyboard

                    
                }
                .onAppear {
                    fetchDeviceLocation()
                    fetchData(for: cityName)
                }
            }
            .refreshable {
                fetchDeviceLocation()
                fetchData(for: cityName) // Reload data when refreshed
                print("refreshed")
            }
        }
    }
    
    private func fetchDeviceLocation() {
        LocationManager.shared.getDeviceLocation { result in
            switch result {
            case .success(let city):
                // Update city name in the UI
                self.cityName = city
                // Fetch weather data based on the obtained city
                fetchData(for: city)
            case .failure(let error):
                self.errorMessage2 = "Error fetching device location! Please check the location permissions or the data connection and try again later."
                
                // Create a DispatchWorkItem to clear the error message after 3 seconds
                let clearErrorMessage = DispatchWorkItem {
                    self.errorMessage2 = nil
                }
                
                // Execute the DispatchWorkItem after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: clearErrorMessage)

            }
        }
    }

        
    func fetchData(for city: String) {
        WeatherDataService.shared.fetchWeatherData(for: city) { result in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    self.temperature = Int(weatherData.current.temperature.rounded())
                    self.summary = weatherData.current.summary
                    self.icon = weatherData.current.icon
                    self.icon_num = weatherData.current.icon_num
                    self.windSpeed = weatherData.current.wind.speed
                    self.windAngle = weatherData.current.wind.angle
                    self.precipitationType = weatherData.current.precipitation.type
                    self.precipitationTotal = weatherData.current.precipitation.total
                    self.cloudCover = weatherData.current.cloud_cover
                    self.currentTime = weatherData.timezone
                    self.updateTime(timezone: weatherData.timezone) // Update current time
                    self.errorMessage = nil

                }
            case .failure(let error):
                self.errorMessage = "Error fetching weather data! Please check the city name or the data connection and try after sometime."
            }
        }
        
        WeatherDataService.shared.fetchHourlyData(for: city) { result in
            switch result {
            case .success(let hourlyData):
                DispatchQueue.main.async {
                    self.hourlyData = hourlyData
                }
            case .failure(let error):
                print("Error fetching hourly forecast data: \(error)")
            }
        }
    }
    
    func updateTime(timezone: String) {
        guard let timeZone = TimeZone(identifier: timezone) else {
            self.currentTime = "Error: Invalid timezone"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "hh:mm a" // Updated format to include AM/PM indicator
        self.currentTime = dateFormatter.string(from: Date())
    }
}
