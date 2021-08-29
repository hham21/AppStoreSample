//
//  RealmDB.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/29.
//

import RealmSwift
import RxSwift

enum LocalError: Error, LocalizedError {
    case realmThreadSolveFailed
    
    var errorDescription: String? {
        switch self {
        case .realmThreadSolveFailed:
            return "RealmStore Solve error"
        }
    }
}

final class RealmDB {
    func read<T: Object>(predicate: NSPredicate?) -> Observable<[T]> {
        return .create { observer in
            autoreleasepool {
                do {
                    let realmStore: Realm = try self.realmStore(type: T.self)
                    var results: Results<T> = realmStore.objects(T.self)

                    if let predicate: NSPredicate = predicate {
                        results = results.filter(predicate)
                    }
                    
                    observer.onNext(results.objects)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func read<T: Object>(predicate: NSPredicate?, sortKV: String, ascending: Bool) -> Observable<[T]> {
        return .create { observer in
            autoreleasepool {
                do {
                    let realmStore: Realm = try self.realmStore(type: T.self)
                    var results: Results<T> = realmStore.objects(T.self)

                    if let predicate: NSPredicate = predicate {
                        results = results.filter(predicate)
                    }
                    
                    observer.onNext(results.objects)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func update<T: Object>(object: T) -> Observable<Void> {
        return .create { observer in
            autoreleasepool {
                do {
                    let realmStore: Realm = try self.realmStore(type: T.self)
                    
                    try realmStore.write {
                        realmStore.add(object, update: .modified)
                        observer.onNext(())
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private func realmStore(type: Object.Type) throws -> Realm {
        let name: String = String(describing: type)
        
        var config: Realm.Configuration = .defaultConfiguration
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.appendPathComponent(name)
        config.fileURL?.appendPathExtension("realm")
        
        let realmStore: Realm = try .init(configuration: config)
        return realmStore
    }
}
