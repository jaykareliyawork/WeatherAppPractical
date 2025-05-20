//
//  WeatherViewModel.swift
//  Weather App Practical
//
//  Created by Jay's work on 19/05/25.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var cityName: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    @Published var humidity: String?
    
    func fetchWeather() async {
        let trimmedCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            errorMessage = "City name cannot be empty."
            return
        }
        
        let apiKey = "3ef994b482e3b3ffdfca94f5edf8b33b"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(trimmedCity)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            return
        }
        updateUI { [weak self] in
            self?.isLoading = true
            self?.errorMessage = nil
            self?.weather = nil
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            updateUI {
                self.weather = decoded
                if let humidity = decoded.main?.humidity {
                    self.humidity = "\(humidity)%"
                }
            }
        } catch {
            updateUI { [weak self] in
                self?.weather = nil
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .timedOut:
                        self?.errorMessage = "Request timed out. Please check your network and try again."
                    case .notConnectedToInternet:
                        self?.errorMessage = "No internet connection."
                    default:
                        self?.errorMessage = "Network error: \(urlError.localizedDescription)"
                    }
                } else if error is DecodingError {
                    self?.errorMessage = "Received unexpected data from server."
                } else {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        try? await Task.sleep(for: .milliseconds(500))
        updateUI { [weak self] in
            self?.isLoading = false
        }
    }
    
    private func updateUI(_ changes: @escaping () -> Void) {
        DispatchQueue.main.async {
            changes()
        }
    }
}
