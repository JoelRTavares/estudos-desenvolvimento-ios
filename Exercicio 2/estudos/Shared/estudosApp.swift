//
//  estudosApp.swift
//  Shared
//
//  Created by Joel Tavares on 27/05/25.
//

import SwiftUI

@main
struct estudosApp: App {
    @StateObject var game=EmojiMemorizeGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
