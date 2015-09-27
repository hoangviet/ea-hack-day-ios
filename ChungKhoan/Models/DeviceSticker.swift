import RealmSwift

class DeviceSticker: Object {
    dynamic var name: String = ""
    dynamic var quantity: Int = 0
    dynamic var unit_value: Float = 0.0
    dynamic var reference_price: Float = 0.0
    dynamic var sticker: Sticker?
    dynamic var device: Device?

    var referencePrice: NSNumber {
        return NSNumber(float: self.reference_price * 1000)
    }
}

