//
//  StickerStore.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/26/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Alamofire
import SwiftyJSON

class StickerStore {
    func getStickerPrices(stickerID: String) -> SignalProducer<[JSON], NoError> {
        return SignalProducer<[JSON], NoError> { sink, _ in
            let request = Alamofire.request(Router.GetStickerPrices(stickerID: stickerID)).responseJSON { _, _, data, _ in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    sendNext(sink, json["prices"].arrayValue)
                    sendCompleted(sink)
                }
            }
            debugPrintln(request)
        }
    }
}