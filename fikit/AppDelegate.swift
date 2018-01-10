//
//  AppDelegate.swift
//  fikit
//
//  Created by Frida Eklund on 2017-10-30.
//

import UIKit

import Firebase
import FirebaseAuth

import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initate firebase
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
 
        let initialViewController = UIStoryboard(name: "launchAnimation", bundle: nil).instantiateViewController(withIdentifier: "launch") as UIViewController
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] =
//        [:]) -> Bool {
//        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//    }
}

