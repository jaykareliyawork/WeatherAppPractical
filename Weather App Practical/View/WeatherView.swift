//
//  ContentView.swift
//  Weather App Practical
//
//  Created by Jay's work on 19/05/25.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var navigate = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter city name", text: $viewModel.cityName)
                    .padding(10)
                    .background(Color(UIColor.white))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top)
                
                Button(action: {
                    Task {
                        await viewModel.fetchWeather()
                    }
                }) {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                        .frame(height: 10)
                        .padding()
                        .background(viewModel.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Form {
                    Section(header: Text("Weather Summary")) {
                        HStack {
                            Text("Temperature:")
                            Spacer()
                            if let temp = viewModel.weather?.main.temp {
                                Text(String(format: "%.1f", temp) + "°C")
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Condition:")
                            Spacer()
                            Text("\(viewModel.weather?.weather.first?.weatherDescription ?? "--")")
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
                        HStack {
                            Text("Latitude:")
                            Spacer()
                            if let temp = viewModel.weather?.coord.lat {
                                Text(String(format: "%.4f", temp))
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Longitude:")
                            Spacer()
                            if let temp = viewModel.weather?.coord.lon {
                                Text(String(format: "%.4f", temp))
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text("\(viewModel.weather?.sys.country ?? "--")")
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                
                Spacer().frame(height: 40)
                
                if !viewModel.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Button(action: {
                        navigate = true
                    }) {
                        Text("Weather Detail")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .buttonStyle(PlainButtonStyle())
                    .transition(.opacity)
                }
                
                NavigationLink(destination: WeatherDetailsView(viewModel: viewModel), isActive: $navigate) {
                }
            }
            .alert("Error", isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { newValue in
                    if !newValue {
                        viewModel.errorMessage = nil
                    }
                }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .navigationTitle("Weather App")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
