//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by rabin on 22/07/2022.
//

import Foundation

struct CurrencyConverter {
    
    func convert(_ amount: Float, fromConversionRate: Float, toConversionRate: Float) -> Float {
        guard fromConversionRate > 0 else { return 0 }
        return amount * (toConversionRate / fromConversionRate)
    }
    
}
