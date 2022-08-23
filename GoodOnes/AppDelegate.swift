//
//  AppDelegate.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import UIKit
import GPhotos

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GPhotos.initialize(with: .init())
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let gphotosHandled = GPhotos.continueAuthorizationFlow(with: url)
        // other app links
        return gphotosHandled
    }
}
