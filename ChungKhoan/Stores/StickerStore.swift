import Foundation
import ReactiveCocoa
import Alamofire
import SwiftyJSON

class StickerStore {
    func getStickerPrices(stickerID: String, within: String) -> SignalProducer<[JSON], NoError> {
        return SignalProducer<[JSON], NoError> { sink, _ in
            let request = Alamofire.request(Router.GetStickerPrices(stickerID: stickerID, within: within)).responseJSON { _, _, data, _ in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    sendNext(sink, json["prices"].arrayValue)
                    sendCompleted(sink)
                    return
                }
            }
            debugPrintln(request)
        }
    }

    func getPriceAlerts(device: String, stickerID: String) -> SignalProducer<JSON, NSError> {
        return SignalProducer<JSON, NSError> { sink, _ in
            let request = Alamofire.request(Router.GetPriceAlerts(device: device, stickerID: stickerID)).responseJSON { _, _, data, _ in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    sendNext(sink, json["price_alert"])
                    sendCompleted(sink)
                    return
                }
                let userInfo = [NSLocalizedDescriptionKey : "Đã có lỗi xảy ra"]
                sendError(sink, NSError(domain: "", code: 1, userInfo: userInfo))
            }
            debugPrintln(request)
        }
    }

    func createPriceAlerts(device: String, stickerID: String, bottom: Float, ceiling: Float) -> SignalProducer<JSON, NSError> {
        return SignalProducer<JSON, NSError> { sink, _ in
            let request = Alamofire.request(Router.CreatePriceAlerts(device: device, stickerID: stickerID, bottom: bottom, ceiling: ceiling)).responseJSON { _, _, data, _ in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    sendNext(sink, json["price_alert"])
                    sendCompleted(sink)
                    return
                }
                let userInfo = [NSLocalizedDescriptionKey : "Đã có lỗi xảy ra"]
                sendError(sink, NSError(domain: "", code: 1, userInfo: userInfo))
            }

            debugPrintln(request)
        }
    }
}