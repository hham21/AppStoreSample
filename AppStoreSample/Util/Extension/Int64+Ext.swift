//
//  Int64+Ext.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit

extension Int64 {
    func to(unit: ByteCountFormatter.Units) -> String {
        let formmater: ByteCountFormatter = ByteCountFormatter()
        formmater.allowedUnits = [unit]
        formmater.countStyle = .binary
        return formmater.string(fromByteCount: self)
    }
}

