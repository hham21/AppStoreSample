//
//  Double+Ext.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Foundation

extension Double {
    var isInteger: Bool {
        rounded(.up) == rounded(.down)
    }
}
