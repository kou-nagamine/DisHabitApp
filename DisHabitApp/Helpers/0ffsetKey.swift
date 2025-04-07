//
//  0ffsetKey.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/07.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
