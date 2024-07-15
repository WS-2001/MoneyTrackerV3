//
//  ExchangeRateView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 15/07/2024.
//

import SwiftUI

struct ExchangeRateView: View {
    @StateObject private var exchangeRateViewModel = ExchangeRateViewModel()
    @State private var baseCurrency: String = "GBP"
    @State private var targetCurrency: String = "EUR"
    @State private var amount: String = ""
    @State private var convertedAmount: String = ""
    @State private var isSwitched: Bool = false

    // List of supported currencies for picker
    let currencies = ["GBP", "EUR", "USD", "JPY", "CAD", "AUD"]

    var body: some View {
        VStack {
            Image(systemName: "sterlingsign.arrow.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color.blue)
            
            // Amount input
            TextField("Amount in \(baseCurrency)", text: $amount)
                .keyboardType(.decimalPad)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .font(.body)
                .foregroundColor(.primary)

            // Currency selection
            HStack {
                // Base currency picker
                Picker("Base Currency", selection: $baseCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding()

                // Switch button
                Button(action: {
                    self.isSwitched.toggle()
                    // Swap base and target currencies
                    let temp = baseCurrency
                    baseCurrency = targetCurrency
                    targetCurrency = temp
                    // Clear converted amount and error message on switch as glitch/bug otherwise
                    convertedAmount = ""
                    exchangeRateViewModel.errorMessage = nil
                }) {
                    Image(systemName: "arrow.left.and.right")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 10)

                // Target currency picker
                Picker("Target Currency", selection: $targetCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding()
            }

            // Convert button with input validation
            Button("Convert") {
                guard !baseCurrency.isEmpty, !targetCurrency.isEmpty, !amount.isEmpty else {
                    exchangeRateViewModel.errorMessage = "Converting a ghost? 👻 Please enter an amount."
                    return
                }

                // API fetch call
                exchangeRateViewModel.fetchExchangeRate(from: baseCurrency, to: targetCurrency)
                if let rate = exchangeRateViewModel.exchangeRate, let amountValue = Double(amount) {
                    let result = isSwitched ? amountValue / rate : amountValue * rate
                    convertedAmount = String(format: "%.2f", result)
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            // Display converted amount ONLY if it is NOT empty
            if !convertedAmount.isEmpty {
                Text("Converted Amount: \(convertedAmount) \(targetCurrency)")
                    .font(.title)
                    .padding()
            }

            // Error message
            if let errorMessage = exchangeRateViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Credits for API
            VStack(spacing: 8) {
                Text("Powered by")
                    .foregroundColor(.gray)
                Link("ExchangeRate-API", destination: URL(string: "https://www.exchangerate-api.com")!)
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding(.top, 20)
            .font(.footnote)
        }
        .padding()
        .navigationTitle("Currency Conversion")
        .onReceive(exchangeRateViewModel.$exchangeRate) { newRate in
            if let rate = newRate, let amountValue = Double(amount) {
                let result = isSwitched ? amountValue / rate : amountValue * rate
                convertedAmount = String(format: "%.2f", result)
            }
        }
        .onAppear {
            // Reset all state variables to initial defaults on view appear
            baseCurrency = "GBP"
            targetCurrency = "EUR"
            amount = ""
            convertedAmount = ""
            isSwitched = false
            exchangeRateViewModel.errorMessage = nil
        }
    }
}
