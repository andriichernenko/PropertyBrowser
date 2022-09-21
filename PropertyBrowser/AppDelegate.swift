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
        
        let browser = PropertyBrowser(
            makeList: { selectItem in
                PropertyListViewer(selectItem: selectItem, propertyService: service)
            },
            makeDetailViewer: { item in
                PropertyDetailViewer(item: item, propertyService: service)
            },
            makePlaceholder: {
                PropertyDetailPlaceholder()
            }
        )
                
        let window = UIWindow()
        window.rootViewController = browser
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

