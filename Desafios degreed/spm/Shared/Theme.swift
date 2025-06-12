//
//  Theme.swift
//  spm
//
//  Created by Joel Tavares on 11/06/25.
//

import SwiftUI

enum ThemeType {
    case light
    case dark
}

struct Theme {
    let background: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    let text: Color
}
