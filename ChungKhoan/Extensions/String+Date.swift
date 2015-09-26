//
//  String+Date.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/26/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation

extension String {
    var date: NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SZ"
        return formatter.dateFromString(self)
    }
}