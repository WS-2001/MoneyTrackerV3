//
//  ExchangeRateViewModel.swift
//  MoneyTrackerV3
//
//  Created by Wares on 15/07/2024.
//

import Foundation
import Combine

// Allowing cancellable to ensure better user experience and no needless resources and bandwidth wasted if user commits to a different action
class ExchangeRateViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var exchangeRate: Double?
    private var cancellable: AnyCancellable?

    // Fetch from API
    func fetchExchangeRate(from baseCurrency: String, to targetCurrency: String) {
        let apiKey = "REMOVED FOR GITHUB"
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(baseCurrency)"
        guard let url = URL(string: urlString) else { return }
        
        // Debug
        print("Fetching exchange rate from URL: \(urlString)")

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ExchangeRateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.exchangeRate = response.conversion_rates[targetCurrency]
                
                // Debug
                print("Fetched exchange rate: \(String(describing: self?.exchangeRate))")
            })
    }
}

// API Response Model
struct ExchangeRateResponse: Codable {
    let conversion_rates: [String: Double]
}
