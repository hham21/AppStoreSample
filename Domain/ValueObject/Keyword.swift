//
//  Keyword.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation

public struct Keyword {
    public let text: String
    public let date: Date
    
    public init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}
