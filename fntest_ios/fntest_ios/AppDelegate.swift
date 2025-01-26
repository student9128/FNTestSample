//
//  AppDelegate.swift
//  fntest_ios
//
//  Created by Kevin Jing on 2024/8/9.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

//@UIApplicationMain
//class AppDelegate: FlutterAppDelegate { // More on the FlutterAppDelegate.
////  lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
//    var flutterEngine : FlutterEngine?
//  lazy var flutterEngine2 = FlutterEngine(name: "my flutter engine2")
//  lazy var flutterEngine3 = FlutterEngine(name: "my flutter engine3")
//
//  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    // Runs the default Dart entrypoint with a default Flutter route.
//      self.flutterEngine = FlutterEngine(name: "ios.flutter")
//      flutterEngine?.run(withEntrypoint: "main");
//      flutterEngine2.run(withEntrypoint: "testN");
//      flutterEngine3.run(withEntrypoint: "testFlutter", libraryURI: "test_fn.dart")
//    // Connects plugins with iOS platform code to this app.
//    GeneratedPluginRegistrant.register(with: self.flutterEngine!);
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
//  }
//}
@main
class AppDelegate: UIResponder, UIApplicationDelegate,FlutterAppLifeCycleProvider {
    
    private let lifecycleDelegate = FlutterPluginAppLifeCycleDelegate()
    let flutterEngine = FlutterEngine(name: "my flutter engine")
      lazy var flutterEngine2 = FlutterEngine(name: "my flutter engine2")
      lazy var flutterEngine3 = FlutterEngine(name: "my flutter engine3")
    func add(_ delegate: any FlutterApplicationLifeCycleDelegate) {
        lifecycleDelegate.add(delegate)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        flutterEngine.run()
              flutterEngine2.run(withEntrypoint: "testN");
//              flutterEngine3.run(withEntrypoint: "testFlutter", libraryURI: "test_fn.dart")
        flutterEngine3.run(withEntrypoint: "testFlutter")
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
        return lifecycleDelegate.application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       lifecycleDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       lifecycleDelegate.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
     }

     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       lifecycleDelegate.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
     }

     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       return lifecycleDelegate.application(app, open: url, options: options)
     }

     func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
       return lifecycleDelegate.application(application, handleOpen: url)
     }

     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       return lifecycleDelegate.application(application, open: url, sourceApplication: sourceApplication ?? "", annotation: annotation)
     }

     func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
       lifecycleDelegate.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
     }

     func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
       lifecycleDelegate.application(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
     }

     func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       lifecycleDelegate.application(application, performFetchWithCompletionHandler: completionHandler)
     }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

