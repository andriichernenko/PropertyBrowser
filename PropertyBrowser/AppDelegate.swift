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
        let view = UIViewController()
        view.view.backgroundColor = .cyan
        
        let window = UIWindow()
        window.rootViewController = view
        window.makeKeyAndVisible()
        self.window = window

        Task {
            let propertyList = try await NetworkPropertyService(session: .shared)
                .fetchPropertyList()
            
            print(">>> \(propertyList)")
            
            let propertyDetails = try await NetworkPropertyService(session: .shared)
                .fetchDetails(for: propertyList.items.first!)
            
            print(">>> \(propertyDetails)")

        }
        
        return true
    }
}

