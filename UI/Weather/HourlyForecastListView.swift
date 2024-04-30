import SwiftUI
import Foundation

struct HourlyForecastListView: View {
    @Binding var hourlyData: [HourlyForecast]

    var body: some View {
        VStack(alignment: .leading) { // Encapsulate within a VStack
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.bottom, -5) 


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(hourlyData) { hourly in
                        VStack {
                            Text(hourly.formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                            Image("\(hourly.iconImageName)") // Use the iconImageName property to provide the image name
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)

                            Text("\(Int(hourly.temperature.rounded()))")
                                .font(.headline)
                                .foregroundColor(.white)

                        }
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.vertical, 15) // Adjust the value to reduce the vertical padding
    }
}
