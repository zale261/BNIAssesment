//
//  AppDelegate.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: HomeRouterImpl.createModule())
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
