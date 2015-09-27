//
//  AddStickerViewModel.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/27/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftyJSON

class AddStickerViewModel {
    var deviceStore = DeviceStore()
    var quantity: Int    = 0
    var unitPrice: Float = 0.0
    let stickerID: String

    init(stickerID: String) {
        self.stickerID = stickerID
    }

    func addSticker() -> SignalProducer<JSON, NSError> {
        return self.deviceStore.addSticker(self.stickerID, toDevice: deviceID, quantity: self.quantity, unitPrice: self.unitPrice)
    }
}