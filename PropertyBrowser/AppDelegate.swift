//
//  AppDelegate.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let service = NetworkPropertyService(session: .shared)
        let listViewer = PropertyListViewer(
            didSelectItem: { print("selected \($0)") },
            propertyService: service
        )
        
        let window = UIWindow()
        window.rootViewController = listViewer
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

