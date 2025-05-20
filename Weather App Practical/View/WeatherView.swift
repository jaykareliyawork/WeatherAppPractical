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
    @State private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Enter city name", text: $viewModel.cityName)
                    .padding(10)
                    .foregroundColor(.primary)
                    .background(
                        isDarkMode ? Color(.systemGray5) : Color.white
                    )
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
                            if let temp = viewModel.weather?.main?.temp {
                                Text(String(format: "%.1f", temp) + "°C")
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Condition:")
                            Spacer()
                            Text("\(viewModel.weather?.weather?.first?.weatherDescription ?? "--")")
                        }
                        HStack {
                            Text("Humidity:")
                            Spacer()
                            TextField("Humidity", text: Binding(
                                get: { viewModel.humidity ?? "--" },
                                set: { viewModel.humidity = $0 }
                            ))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        }
                        HStack {
                            Text("Latitude:")
                            Spacer()
                            if let temp = viewModel.weather?.coord?.lat {
                                Text(String(format: "%.4f", temp))
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Longitude:")
                            Spacer()
                            if let temp = viewModel.weather?.coord?.lon {
                                Text(String(format: "%.4f", temp))
                            } else {
                                Text("--")
                            }
                        }
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text("\(viewModel.weather?.sys?.country ?? "--")")
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(width: 100, height: 50)
                }
                
                Spacer().frame(height: 10)
                
                VStack {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .padding(.horizontal, 30)
                }
                                
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
                    Spacer().frame(height: 10)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
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
            .navigationDestination(isPresented: $navigate) {
                WeatherDetailsView(viewModel: viewModel)
            }
        }
    }
}

//#Preview {
//    WeatherView()
//}
