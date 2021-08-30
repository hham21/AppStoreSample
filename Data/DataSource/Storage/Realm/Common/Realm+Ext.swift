//
//  Realm+Ext.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/29.
//

import RealmSwift

extension Realm {
    /// Managed Object를 async하게 사용할 필요 있을 경우 사용
    func writeAsync<T: ThreadConfined>(_ passedObject: T,
                                       queue: DispatchQueue = DispatchQueue(label: "background"),
                                       block: @escaping ((Realm, T?) -> Void),
                                       errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return }) {
        let objectReference: ThreadSafeReference<T> = .init(to: passedObject)
        let configuration: Realm.Configuration = self.configuration
        
        DispatchQueue.init(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: configuration)
                    try realm.write {
                        let object = realm.resolve(objectReference)
                        block(realm, object)
                    }
                } catch {
                    errorHandler(error)
                }
            }
        }
    }
}

extension Results {
    var objects: [Element] {
        let indexes: IndexSet = .init(integersIn: 0..<count)
        return objects(at: indexes)
    }
}
