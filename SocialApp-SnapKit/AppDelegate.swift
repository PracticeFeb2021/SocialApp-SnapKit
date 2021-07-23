//
//  AppDelegate.swift
//  SocialApp-MVC
//
//  Created by Oleksandr Bretsko on 2/13/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let rootVC = PostListVC()
        rootVC.netService = NetworkManager.shared
        let rootNC = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        return true
    }
}

