//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Andre Labbe on 09/06/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
 
 
    let currencyAmount: Double
    let idQuote: String
    let idBase: String
    
    var currencyAmountString: String {
        // convert the double to a proper currency value. Right now it is the User Default
        // we could match the displayed currency if we wanted to be...
        let amount = convertDoubleToCurrency(amount: currencyAmount)
        // we get rid of the currency sign at the start of the string and return the value
        let range = amount.index(after: amount.startIndex)..<amount.endIndex
        return String(amount[range])

    }
    
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
}
