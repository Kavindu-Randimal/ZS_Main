//
//  AppDelegate.swift
//  AuditTrailClip
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .lightGray
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            window.rootViewController = UIViewController()
            window.makeKeyAndVisible()
        }
        return true
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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        //Branch.getInstance().continue(userActivity)
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            guard
                  let incomingURL = userActivity.webpageURL,
                  let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                  let queryItems = components.queryItems else {
                print("Nothing")
                return false
            }
            
            if let _id = queryItems.first(where: {$0.name == "smoothie"}) {
                print("smoothie - \(_id)")
            }
        }
        
        print("ddf")
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            guard
                  let incomingURL = userActivity.webpageURL,
                  let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                  let queryItems = components.queryItems else {
                print("Nothing")
                return false
            }
            
            if let _id = queryItems.first(where: {$0.name == "smoothie"}) {
                print("smoothie - \(_id)")
            }
        }
        return true
    }
    
    func setAsRoot(_controller: UIViewController) {
        if window != nil {
            window?.rootViewController = _controller
        }
    }
}

