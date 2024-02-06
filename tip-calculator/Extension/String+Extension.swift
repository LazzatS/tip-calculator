//
//  String+Extension.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 04.02.2024.
//

import Foundation

extension String {
    var doubleValue: Double? {
        Double(self)
    }
    
    var currencySymbol: String {
        return NumberFormatter().currencySymbol
    }
}
