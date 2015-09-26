//
//  Device.swift
//  ChungKhoan
import RealmSwift
import Alamofire

class Device: Object {
    dynamic var device_id: String = NSUUID().UUIDString
    dynamic var total_asset: Float = 0.0
    dynamic var portfolio_gain: Float = 0.0
    dynamic var portfolio_gain_in_percentage: Float = 0

    var totalAsset: NSNumber {
        return NSNumber(float: self.total_asset)
    }
    var portfolioGain: NSNumber {
        return NSNumber(float: self.portfolio_gain)
    }
    var portfolioGainInPercentage: NSNumber {
        return NSNumber(float: self.portfolio_gain_in_percentage)
    }
    let stickers = List<DeviceSticker>()
    
    override static func primaryKey() -> String? {
        return "device_id"
    }
}

final class DeviceService {
    typealias DeviceServiceFailureHandler = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void
    
    class func currentDevice() -> (Device) {
        let realm = Realm()
        if let device = realm.objects(Device).first {
            return device
        } else {
            realm.write {
                return realm.create(Device.self, value: Device(), update: true)
            }
        }
        // Return temporary device
        // TODO hmm, should think about this
        return Device()
    }
    
    class func fetchStickers(#device: Device, success: (Device) -> Void, failure: DeviceServiceFailureHandler? = nil) {
        let request = Alamofire.request(Router.GetDeviceStickers(device: device.device_id)).responseJSON { (_, response, data, error) in
            if let data: AnyObject = data {
                let stickers = data["stickers"] as! [NSDictionary]
                let meta = data["meta"] as! NSDictionary
                let realm = Realm()
                realm.write {
                    if let total_asset: AnyObject = meta.objectForKey("total_asset") {
                        device.total_asset = total_asset.floatValue
                    }
                    
                    if let portfolio_gain: AnyObject = meta.objectForKey("portfolio_gain") {
                        device.portfolio_gain = portfolio_gain.floatValue
                    }
                    
                    for sticker in stickers {
                        if let stickerName = sticker.objectForKey("name") as? String {
                            var deviceSticker = realm.objects(DeviceSticker).filter("sticker.name == '\(stickerName)' AND device.device_id == '\(device.device_id)'").first
                            if let deviceSticker = deviceSticker {
                                 realm.delete(deviceSticker)
                            }
                            deviceSticker = DeviceSticker(value: sticker)
                            deviceSticker!.sticker = realm.objects(Sticker).filter("name == '\(stickerName)'").first
                            deviceSticker!.device = device
                            device.stickers.append(deviceSticker!)
                        }
                    }
                    success(device)
                    return
                }
            }
            if let failure = failure {
                failure(response, data, error)
            }
        }
        debugPrintln(request)
    }
    
    class func add(#sticker: Sticker, toDevice: Device, quantity: Int, unitPrice: Float, success: () -> Void, failure: DeviceServiceFailureHandler) {
        let request = Alamofire.request(Router.AddStickerToDevice(name: sticker.name, device: toDevice.device_id, qty: quantity, unitPrice: unitPrice))
            .responseJSON { (_, response, data, error) in
                if let data: AnyObject = data {
                    success()
                    return
                }
                failure(response, data, error)
        }
        debugPrintln(request)
    }
}