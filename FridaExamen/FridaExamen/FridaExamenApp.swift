//
//  FridaExamenApp.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

import SwiftUI


@main
struct FridaExamenApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active: // Foreground
                print("App State : Active")
            @unknown default:
                 print("App State : Unknown")
            }
        }
    }
}
