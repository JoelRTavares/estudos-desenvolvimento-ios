//
//  ThemeViewModel.swift
//  spm
//
//  Created by Joel Tavares on 11/06/25.
//
import SwiftUI

class ThemeViewModel: ObservableObject {
    @Published var themeType: ThemeType = .light

    var currentTheme: Theme {
        switch themeType {
        case .light: return ThemeManager.light
        case .dark: return ThemeManager.dark
        }
    }

    func toggleTheme() {
        themeType = (themeType == .light) ? .dark : .light
    }
}
