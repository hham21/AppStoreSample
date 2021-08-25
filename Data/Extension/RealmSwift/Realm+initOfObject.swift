//
//  Realm+initOfObject.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import RealmSwift

extension Realm {
    init(of object: Object.Type) throws {
        let name = String(describing: object)
        
        var config = Configuration.defaultConfiguration
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.appendPathComponent(name)
        config.fileURL?.appendPathExtension("realm")
        
        try self.init(configuration: config)
    }
}
