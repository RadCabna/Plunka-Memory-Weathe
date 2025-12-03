//
//  Plunka_Memory_WeatheApp.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 27.11.2025.
//

import SwiftUI

@main
struct Plunka_Memory_WeatheApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, URLSessionDelegate {
    @AppStorage("levelInfo") var level = false
    @AppStorage("valid") var validationIsOn = false
    static var orientationLock = UIInterfaceOrientationMask.all
    private var validationPerformed = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if OrientationManager.shared.isHorizontalLock {
            return .portrait
        } else {
            return .allButUpsideDown
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func setOrientation(to orientation: UIInterfaceOrientation) {
        switch orientation {
        case .portrait:
            AppDelegate.orientationLock = .portrait
        case .landscapeRight:
            AppDelegate.orientationLock = .landscapeRight
        case .landscapeLeft:
            AppDelegate.orientationLock = .landscapeLeft
        case .portraitUpsideDown:
            AppDelegate.orientationLock = .portraitUpsideDown
        default:
            AppDelegate.orientationLock = .all
        }
        
        // Request geometry update for iOS 16+
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: AppDelegate.orientationLock)
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                print("Geometry update error: \(error.localizedDescription)")
            }
        }
    }
    
}
