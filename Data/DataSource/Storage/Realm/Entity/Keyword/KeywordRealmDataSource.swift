//
//  KeywordRealmDataSource.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift
import RealmSwift

public struct KeywordRealmDataSource: KeywordDataSource {

    public init() {}

    public func getKeywords() -> Observable<[Keyword]> {
        .create { observer in
            do {
                let realm = try Realm(of: RMKeyword.self)
                let objects = realm.objects(RMKeyword.self)
                    .sorted(byKeyPath: #keyPath(RMKeyword.date), ascending: false)
                let data = Array(objects).compactMap { $0.asDomain() }
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                dump(error)
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        .create { observer in
            do {
                let realm = try Realm(of: RMKeyword.self)
                let predicate = NSPredicate(format: "\(#keyPath(RMKeyword.text)) CONTAINS[cd] %@", argumentArray: [text as NSString])
                let objects = realm.objects(RMKeyword.self)
                    .filter(predicate)
                    .sorted(byKeyPath: #keyPath(RMKeyword.date), ascending: false)
                let data = Array(objects)
                    .compactMap { $0.asDomain() }
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                dump(error)
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    public func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        .create { observer in
            do {
                let item = keyword.asRealm()
                let realm = try Realm(of: RMKeyword.self)
                
                let semaphore = DispatchSemaphore(value: 0)
                
                try realm.write {
                    realm.add(item, update: .modified)
                    semaphore.signal()
                }
                
                semaphore.wait()

                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}
