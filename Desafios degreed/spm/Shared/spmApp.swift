//
//  spmApp.swift
//  Shared
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI

@main
struct spmApp: App {
    @StateObject var themeVM = ThemeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeVM)
        }
    }
}
