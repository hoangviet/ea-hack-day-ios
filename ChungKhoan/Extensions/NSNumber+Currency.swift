//
//  NSNumber+Currency.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/26/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation

extension NSNumber {
    var currency: String {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "es_VN")
        return formatter.stringFromNumber(self)!
    }
}