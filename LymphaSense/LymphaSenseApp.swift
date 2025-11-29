//
//  LymphaSenseApp.swift
//  LymphaSense
//
//  Created by Lindsay on 10/27/25.
//

import SwiftUI
import UIKit

@main
struct LymphaSenseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            ContentView()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
    }
}
