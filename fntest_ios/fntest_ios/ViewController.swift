//
//  ViewController.swift
//  fntest_ios
//
//  Created by Kevin Jing on 2024/8/9.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make a button to call the showFlutter function when pressed.
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
        button.setTitle("Show Flutter!", for: UIControl.State.normal)
        button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        
        let button2 = UIButton(type:UIButton.ButtonType.custom)
        button2.addTarget(self, action: #selector(showFlutter2), for: .touchUpInside)
        button2.setTitle("Show Flutter2", for: UIControl.State.normal)
        button2.frame = CGRect(x: 80.0, y: 260.0, width: 160.0, height: 40.0)
        button2.backgroundColor = UIColor.blue
        self.view.addSubview(button2)
        
        let button3 = UIButton(type:UIButton.ButtonType.custom)
        button3.addTarget(self, action: #selector(showFlutter3), for: .touchUpInside)
        button3.setTitle("Show Flutter3", for: UIControl.State.normal)
        button3.frame = CGRect(x: 80.0, y: 310.0, width: 160.0, height: 40.0)
        button3.backgroundColor = UIColor.blue
        self.view.addSubview(button3)
      }

      @objc func showFlutter() {
          let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
//          let flutterViewController = FlutterViewController(engine:flutterEngine)
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        present(flutterViewController, animated: true, completion: nil)
      }
    @objc func showFlutter2() {
//      let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine2
//      let flutterViewController =
//          FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//        print("\(self.navigationController)")
//      present(flutterViewController, animated: true, completion: nil)
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled=true
        self.navigationController?.interactivePopGestureRecognizer?.delegate=self
//        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
//              edgeGesture.edges = .left
//              self.view.addGestureRecognizer(edgeGesture)
//        self.navigationController?.pushViewController(flutterViewController, animated: true)

        
        let vc = CustomFlutterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func handleEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
          if gesture.state == .ended {
              // 执行返回操作
              self.navigationController?.popViewController(animated: true)
          }
      }
    
    @objc func showFlutter3() {
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled=true
        self.navigationController?.interactivePopGestureRecognizer?.delegate=self
//        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
//              edgeGesture.edges = .left
//              self.view.addGestureRecognizer(edgeGesture)
//        self.navigationController?.pushViewController(flutterViewController, animated: true)

        
        let vc = CustomFlutterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController :UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         // 确保侧滑手势可以工作
        return true
     }
}
