//
//  Stringextensions.swift
//  spm
//
//  Created by Joel Tavares on 10/06/25.
//

import Foundation

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to)
        return String(self[start..<end])
    }
}
