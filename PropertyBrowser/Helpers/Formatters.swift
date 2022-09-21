//
//  Formatters.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import Foundation

extension MonetaryAmount {
    
    var formatted: String {
        monetaryAmountFormatter.string(from: NSDecimalNumber(decimal: self)) ?? "\(self)"
    }
}

// TODO: use the actual locale
let locale = Locale(identifier: "en_SE")

private let monetaryAmountFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currencyISOCode
    formatter.maximumFractionDigits = 0
    
    return formatter
}()
