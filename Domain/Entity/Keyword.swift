//
//  Keyword.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation

public class Keyword: Identifiable {
    public let text: String
    public let date: Date
    
    public var id: String {
        return text
    }
    
    public init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}
