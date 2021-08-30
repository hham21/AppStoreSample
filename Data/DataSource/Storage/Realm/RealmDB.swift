//
//  RealmDB.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/29.
//

import RealmSwift
import RxSwift

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
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(on: MainScheduler.instance)
    }
    
    func delete<T: Object>(object: T) -> Observable<Void> {
        return .create { observer in
            autoreleasepool {
                do {
                    let realmStore: Realm = try self.realmStore(type: T.self)
                    
                    try realmStore.write {
                        realmStore.delete(object)
                        observer.onNext(())
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(on: MainScheduler.instance)
    }
    
    func deleteAll<T: Object>(type: T.Type) -> Observable<Void> {
        return .create { observer in
            autoreleasepool {
                do {
                    let realmStore: Realm = try self.realmStore(type: T.self)
                    
                    let objects: Results<T> = realmStore.objects(T.self)
                    
                    try realmStore.write {
                        realmStore.delete(objects)
                        observer.onNext(())
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
                
                return Disposables.create()
            }
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(on: MainScheduler.instance)
    }
    
    func observe<T: Object>(type: T.Type) -> Observable<Void> {
        return .create { observer in
            do {
                let realm = try self.realmStore(type: T.self)
                
                let token = realm.observe { _, _ in
                    observer.onNext(())
                }
                
                return Disposables.create {
                    token.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(on: MainScheduler.instance)
    }
    
    private func realmStore(type: Object.Type) throws -> Realm {
        let name = String(describing: type)
        
        let realmsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Realms")
        
        if !FileManager.default.fileExists(atPath: realmsUrl.path) {
            try FileManager.default.createDirectory(at: realmsUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        let realmUrl = realmsUrl
            .appendingPathComponent(name)
            .appendingPathExtension("realm")
        
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = realmUrl
        
        return try Realm(configuration: config)
    }
}
