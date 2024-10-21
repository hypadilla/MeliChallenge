//
//  Double+Currency.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import Foundation

extension Double {
    /// Formats the double value as a currency string.
    ///
    /// - Parameters:
    ///   - symbol: The currency symbol to be used. Default is "$".
    ///   - locale: The locale to be used for formatting. Default is the current locale.
    /// - Returns: The formatted currency string.
    func formattedAsCurrency(symbol: String = "$", locale: Locale = Locale.current) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = symbol
        numberFormatter.locale = locale
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
