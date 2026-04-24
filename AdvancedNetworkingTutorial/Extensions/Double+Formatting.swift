//
//  Double+Formatting.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 24/04/26.
//
import Foundation

extension Double {
    func formattedCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        formatter.maximumFractionDigits = self >= 1 ? 2 : 6
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }

    func formattedPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self / 100)) ?? "\(self)%"
    }
}

