import Alamofire
import SwiftyJSON
import RealmSwift

class Sticker: Object {
    dynamic var name: String = ""
    dynamic var title: String = ""
    dynamic var reference_price: ReferencePrice?
    let prices = List<Price>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

final class StickerService {
    typealias StickerSuccessHandler = (Results<Sticker>) -> Void
    typealias StickerFailureHandler = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void
    
    class func fetch(#sticker: Sticker, success: (Sticker) -> Void, failure: StickerFailureHandler) {
        Alamofire.request(Router.GetSticker(name: sticker.name))
            .responseJSON { (_, response, data, error) in
                if let data: AnyObject = data {
                    let sticker = data["sticker"] as! NSDictionary
                    let realm = Realm()
                    realm.write {
                        success(realm.create(Sticker.self, value: sticker, update: true))
                        return
                    }
                }
                failure(response, data, error)
        }
    }
    
    class func searchBy(#query: String, success: StickerSuccessHandler, failure: StickerFailureHandler) {
        Alamofire.request(Router.GetStickers)
            .responseJSON { (_, response, data, error) in
                if let data: AnyObject = data {
                    let stickers = data["stickers"] as! [NSDictionary]
                    let realm = Realm()
                    realm.write {
                        for sticker in stickers  {
                            realm.create(Sticker.self, value: sticker, update: true)
                        }
                    }
                    let results = realm.objects(Sticker)
                        .filter("name BEGINSWITH '\(query.uppercaseString)'")
                        .sorted("name")
                    success(results)
                } else {
                    failure(response, data, error)
                }
                
        }
    }

}