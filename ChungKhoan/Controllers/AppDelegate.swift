import UIKit
import Fabric
import Crashlytics
import RealmSwift
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        Parse.setApplicationId("Def6BR2HfIbLhdNyYmXteGoqINyMLI6nl14Mfbr2", clientKey: "dATiLnoda7htrrQkWSC5pjmTQkV6jVMGFQu2ACJG")
        
        UINavigationBar.appearance().barTintColor        = UIColor.barTintColor()
        UINavigationBar.appearance().tintColor           = UIColor.barForegroundColorColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.barForegroundColorColor()]
        
        println("Device ID: \(DeviceService.currentDevice().device_id)")
        let realm = Realm()
        println("DB Path: \(realm.path)")

        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        let installation = PFInstallation.currentInstallation()
        installation.addUniqueObject(NSUUID().UUIDString, forKey: "channels")
        installation.saveEventually()
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveEventually()
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
}
