import Alamofire

// Mark - Router
enum Router: URLRequestConvertible {
    static let baseURLString = "http://chungkhoan-api.nogias.com"
    case GetStickers
    case GetSticker(name: String)
    case GetDeviceStickers(device: String)
    case AddStickerToDevice(name: String, device: String, qty: Int, unitPrice: Float)
    case GetStickerPrices(stickerID: String, within: String)
    case CreatePriceAlerts(device: String, stickerID: String, bottom: Float, ceiling: Float)
    case GetPriceAlerts(device: String, stickerID: String)

    var method: Alamofire.Method {
        switch self {
        case .AddStickerToDevice, .CreatePriceAlerts:
            return .POST
        default:
            return .GET
        }
    }
    // MARK: URLRequestConvertible
    var URLRequest: NSURLRequest {
        let (path: String, parameters: [String: AnyObject]?) = {
            switch self {
                case .GetStickers:
                    return ("/stickers", nil)
                case .GetSticker(let name):
                    return ("/stickers/\(name)", nil)
                case .GetDeviceStickers(let device):
                    return ("/devices/\(device)/stickers", nil)
                case .AddStickerToDevice(let sticker, let device, let qty, let unitPrice):
                    return ("/devices/\(device)/stickers", ["sticker_id": sticker, "quantity": qty, "unit_value": unitPrice])
                case .GetStickerPrices(let stickerID, let within):
                    return ("/stickers/\(stickerID)/prices", ["within": within])
                case .CreatePriceAlerts(let device, let stickerID, let bottom, let ceiling):
                    return ("/devices/\(device)/stickers/\(stickerID)/price_alerts", ["bottom": bottom, "ceiling": ceiling])
                case .GetPriceAlerts(let device, let stickerID):
                    return ("/devices/\(device)/stickers/\(stickerID)/price_alerts", nil)
            }
            }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}