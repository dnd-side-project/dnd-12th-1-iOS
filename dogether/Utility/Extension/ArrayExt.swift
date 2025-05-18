//
//  ArrayExt.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
