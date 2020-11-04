import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
//    if #available(iOS 10.0, *) {
//          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//        }
    
    GMSServices.provideAPIKey("AIzaSyB0IHV3sQwQlLx1U4VIle8Rr8DsCFEgriM")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
