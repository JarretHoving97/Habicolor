//
//  AppDelegate.swift
//  habicolor-2.0
//
//  Created by Jarret Hoving on 18/12/2023.
//

import UIKit
import Firebase
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private(set) var transactionListener: TransactionListeneer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        transactionListener = TransactionListeneer()
        
        if Environment.current == .production {
            FirebaseApp.configure()
            AppAnalytics.logEvent(.init(name: .didLaunch, value: nil))
        }
  
        return true
    }
}
