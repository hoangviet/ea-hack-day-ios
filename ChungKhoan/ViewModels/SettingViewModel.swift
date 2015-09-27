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
                self.bottom  = json["bottom"].floatValue * 1000
                self.ceiling = json["ceiling"].floatValue * 1000
            })
    }

    func createPriceAlerts() -> SignalProducer<JSON, NSError> {
        return self.stickerStore.createPriceAlerts(deviceID,
            stickerID: self.stickerID,
            bottom: self.bottom / 1000,
            ceiling: self.ceiling / 1000)
    }
}