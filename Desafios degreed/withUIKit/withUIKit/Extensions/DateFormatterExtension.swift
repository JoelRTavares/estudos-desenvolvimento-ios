//
//  DateFormatterExtension.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
