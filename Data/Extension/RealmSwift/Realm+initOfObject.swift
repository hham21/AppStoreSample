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
        
        let realmsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Realms")
        
        if !FileManager.default.fileExists(atPath: realmsUrl.path) {
            try FileManager.default.createDirectory(at: realmsUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        let realmUrl = realmsUrl
            .appendingPathComponent(name)
            .appendingPathExtension("realm")
        
        var config = Configuration.defaultConfiguration
        config.fileURL = realmUrl
        
        try self.init(configuration: config)
    }
}
