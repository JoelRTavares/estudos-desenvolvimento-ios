//
//  ThemeManager.swift
//  spm
//
//  Created by Joel Tavares on 11/06/25.
//

import SwiftUI

struct ThemeManager {
    static let dark = Theme(
        background: Color(red: 0.0, green: 0.06, blue: 0.24),
        primary: Color(red: 0.02, green: 0.27, blue: 0.48),
        secondary: Color(red: 0.08, green: 0.58, blue: 0.69),
        accent: Color(red: 0.26, green: 0.78, blue: 0.81),
        text: Color(red: 0.78, green: 0.94, blue: 0.95)
    )

    static let light = Theme(
        background: Color.white,
        primary: Color.gray,
        secondary: Color(red: 0.18, green: 0.08, blue: 0.10),
        accent: Color(red: 0.75, green: 0.12, blue: 0.24),
        text: Color.black
    )
}
