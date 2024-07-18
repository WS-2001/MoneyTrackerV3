//
//  FuturePredictionsViewModel.swift
//  MoneyTrackerV3
//
//  Created by Wares on 18/07/2024.
//
import Foundation
import CoreML

// This was the most annoying aspect of the entire app and I hated it :(
class FuturePredictionsViewModel: ObservableObject {
    @Published var predictedNetBalances: [Double] = []
    private let netBalancePredictor: NetBalancePredictor

    init(netBalancePredictor: NetBalancePredictor) {
        self.netBalancePredictor = netBalancePredictor
    }

    // Predicting future net balances based on transactions. The more data over a long period of time, the more accurate it will become. It will not be that accurate at first.
    func predictFutureNetBalances(for friend: Friend) {
        let calendar = Calendar.current
        var currentDate = Date()
        var endDate = calendar.date(byAdding: .month, value: 1, to: Date())!
        var predictedNetBalances: [Double] = []

        // For every day (for the next month), perform prediction
        while currentDate <= endDate {
            let day = Double(calendar.component(.day, from: currentDate))
            let month = Double(calendar.component(.month, from: currentDate))
            let year = Double(calendar.component(.year, from: currentDate))
            let totalLend = friend.totalLend
            let totalBorrow = friend.totalBorrow

            do {
                // Create MLMultiArray with 5 elements for CoreML model
                let inputArray = try MLMultiArray(shape: [5], dataType: .double)
                inputArray[0] = NSNumber(value: day)
                inputArray[1] = NSNumber(value: month)
                inputArray[2] = NSNumber(value: year)
                inputArray[3] = NSNumber(value: totalLend)
                inputArray[4] = NSNumber(value: totalBorrow)

                // Create instance of NetBalancePredictorInput and predict future net balance
                let input = NetBalancePredictorInput(input_1: inputArray)
                let prediction = try netBalancePredictor.prediction(input: input)

                // Get the predicted net balance value
                if let netBalance = prediction.featureValue(for: "Identity")?.multiArrayValue {
                    let predictedNetBalance = netBalance[0].doubleValue
                    predictedNetBalances.append(predictedNetBalance)
                } else {
                    // Debug
                    print("Retrieval failed for \(currentDate)")
                }
            } catch {
                // Debug
                print("Prediction failed for \(currentDate) with error: \(error.localizedDescription)")
            }

            // Move onto next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        self.predictedNetBalances = predictedNetBalances
    }
}
