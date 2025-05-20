//
//  WeatherDetailsView.swift
//  Weather App Practical
//
//  Created by Jay's work on 19/05/25.
//

import SwiftUI

struct WeatherDetailsView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        Form {
            Section(header: Text("Detailed Weather")) {
                HStack {
                    Text("Pressure (hPa):")
                    Spacer()
                    if let temp = viewModel.weather?.main.pressure {
                        Text(String(temp))
                    } else {
                        Text("--")
                    }
                }

                HStack {
                    Text("Wind Speed (m/s):")
                    Spacer()
                    if let temp = viewModel.weather?.wind.speed {
                        Text(String(format: "%.1f", temp))
                    } else {
                        Text("--")
                    }
                }

                HStack {
                    Text("Humidity:")
                    Spacer()
                    if let temp = viewModel.weather?.main.humidity {
                        Text(String(temp) + "%")
                    } else {
                        Text("--")
                    }
                }
            }
        }
    }
}
