//
//  SpartnerApp.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SpartnerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var trackManager = TrackManager()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(trackManager)
        }
    }
}
