import RealmSwift

class ReferencePrice: Object {
    dynamic var value: Float = 0.0
    dynamic var updatedAt = NSDate(timeIntervalSince1970: 1)

    var price: NSNumber {
        return NSNumber(float: self.value * 1000)
    }
}
