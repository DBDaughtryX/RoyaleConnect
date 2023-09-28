//
//  RoyaleConnectApp.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Firebase
@main
struct RoyaleConnectApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
