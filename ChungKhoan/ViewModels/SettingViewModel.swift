//
//  SettingViewModel.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/27/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftyJSON

class SettingViewModel {
    var stickerStore = StickerStore()
    var bottom: Float = 0
    var ceiling: Float = 0
    let stickerID: String

    init(stickerID: String) {
        self.stickerID = stickerID
    }

    func createPriceAlerts() -> SignalProducer<JSON, NoError> {
        return self.stickerStore.createPriceAlerts(NSUUID().UUIDString,
            stickerID: self.stickerID,
            bottom: self.bottom,
            ceiling: self.ceiling)
    }
}