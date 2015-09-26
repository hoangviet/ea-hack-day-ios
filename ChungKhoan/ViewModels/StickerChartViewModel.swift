//
//  StickerChartViewModel.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/26/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftyJSON

let within1Week  = "1w"
let within2Weeks = "2w"
let within1Month = "1m"

class StickerChartViewModel {
    let stickerID: String
    var within: String = "1w"
    var stickerStore = StickerStore()
    var prices: [Float]?
    var dates: [String]?

    init(stickerID: String) {
        self.stickerID = stickerID
    }

    func setWithinWithTag(tag: Int) {
        switch tag {
        case 0:
            self.within = within1Week
        case 1:
            self.within = within2Weeks
        case 2:
            self.within = within1Month
        default:
            break
        }
    }

    func getStickerPrices() -> SignalProducer<[JSON], NoError> {
        return self.stickerStore.getStickerPrices(self.stickerID)
            |> on(next: { priceJSONs in
                var values = [Float]()
                var dates = [String]()
                for price in priceJSONs {
                    values.append(price["value"].floatValue)
                    if let date = price["updated_at"].stringValue.date {
                        dates.append("1")
                    } else {
                        dates.append("N/A")
                    }

                }
                self.prices = values
                self.dates  = dates
            })
    }
}