import Foundation
import ReactiveCocoa
import SwiftyJSON
import Alamofire

class DeviceStore {
    func addSticker(stickerID: String, toDevice device: String, quantity: Int, unitPrice: Float) -> SignalProducer<JSON, NSError> {
        return SignalProducer<JSON, NSError> { sink, _ in
            let request = Alamofire.request(Router.AddStickerToDevice(name: stickerID, device: device, qty: quantity, unitPrice: unitPrice)).responseJSON { _, _, data, _ in
                if let data: AnyObject = data {
                    let json = JSON(data)
                    sendNext(sink, json)
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