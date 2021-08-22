//
//  DBObject.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/04.
//

import Foundation

protocol DBObject: Codable {
    var id: String { get }
}
