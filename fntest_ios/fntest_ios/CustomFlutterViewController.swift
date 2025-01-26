//
//  CustomFlutterViewController.swift
//  fntest_ios
//
//  Created by Kevin Jing on 1/22/25.
//

import Foundation
import Flutter
class CustomFlutterViewController:UIViewController{
    private var flutterEngine: FlutterEngine?
    var channel:FlutterMethodChannel?
    override func viewDidLoad() {
        flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine2
        self.flutterEngine?.run(withEntrypoint: "testN")
        let flutterViewController =
            FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
        flutterViewController.view.frame = self.view.bounds
        self.addChild(flutterViewController)
        self.view.addSubview(flutterViewController.view)
        flutterViewController.didMove(toParent: self)
        channel = FlutterMethodChannel(name: "iosTest", binaryMessenger:self.flutterEngine!.binaryMessenger)
        channel!.invokeMethod("jump", arguments: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("pop======1");
//        channel?.invokeMethod("pop", arguments: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("pop======2");
        channel?.invokeMethod("pop", arguments: nil)
    }

}
