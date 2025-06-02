//
//  blackjckApp.swift
//  Shared
//
//  Created by Joel Tavares on 30/05/25.
//

import SwiftUI

@main
struct blackjckApp: App {
    @StateObject var game = BlackJackEmojiCardGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
