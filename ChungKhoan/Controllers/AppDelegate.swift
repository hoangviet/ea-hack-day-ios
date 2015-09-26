import UIKit
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        
        UINavigationBar.appearance().barTintColor        = UIColor.barTintColor()
        UINavigationBar.appearance().tintColor           = UIColor.barForegroundColorColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.barForegroundColorColor()]
        
        println("Device ID: \(DeviceService.currentDevice().device_id)")
        let realm = Realm()
        println("DB Path: \(realm.path)")
        return true
    }
}
