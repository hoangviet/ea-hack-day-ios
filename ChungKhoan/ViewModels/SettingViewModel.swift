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

    func getPriceAlerts() -> SignalProducer<JSON, NSError> {
        return self.stickerStore.getPriceAlerts(deviceID, stickerID: self.stickerID)
            |> on(next: { json in
                self.bottom  = json["bottom"].floatValue
                self.ceiling = json["ceiling"].floatValue
            })
    }

    func createPriceAlerts() -> SignalProducer<JSON, NSError> {
        return self.stickerStore.createPriceAlerts(deviceID,
            stickerID: self.stickerID,
            bottom: self.bottom,
            ceiling: self.ceiling)
    }
}