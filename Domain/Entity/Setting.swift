//
//  Setting.swift
//  Domain
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Foundation

public struct Setting {
    public let isInternalMode: Bool
    
    public init() {
        self.isInternalMode = false
    }
    
    public init(isInternalMode: Bool) {
        self.isInternalMode = isInternalMode
    }
}

extension Setting: Equatable {
    public static func == (lhs: Setting, rhs: Setting) -> Bool {
        lhs.isInternalMode == rhs.isInternalMode
    }
}

extension Setting: Hashable {}
