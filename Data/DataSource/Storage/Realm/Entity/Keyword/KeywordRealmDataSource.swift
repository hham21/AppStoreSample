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
    private let DB: RealmDB = .init()

    public init() {}

    public func getKeywords() -> Observable<[Keyword]> {
<<<<<<< HEAD:Data/DataSource/Storage/Realm/Entity/Keyword/KeywordRealmDataSource.swift
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
=======
        return readKeywords()
            .compactMap { $0.compactMap { $0.asDomain() } }
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        let predicate: NSPredicate = .init(
            format: "\(#keyPath(RMKeyword.text)) CONTAINS[cd] %@",
            argumentArray: [text as NSString]
        )
        return readKeywords(predicate: predicate)
            .compactMap { $0.compactMap { $0.asDomain() } }
>>>>>>> 66b0c3b7ff8c3618950c968a4fb74b60a4cfeeb4:Data/DataSource/Storage/Realm/KeywordRealmDataSource.swift
    }
    
    public func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
<<<<<<< HEAD:Data/DataSource/Storage/Realm/Entity/Keyword/KeywordRealmDataSource.swift
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
=======
        return updateKeyword(keyword)
    }
    
    private func readKeywords(predicate: NSPredicate? = nil) -> Observable<[RMKeyword]> {
        return DB.read(predicate: predicate)
    }
    
    private func updateKeyword(_ keyword: Keyword) -> Observable<Void> {
        return DB.update(object: keyword.asRealm())
>>>>>>> 66b0c3b7ff8c3618950c968a4fb74b60a4cfeeb4:Data/DataSource/Storage/Realm/KeywordRealmDataSource.swift
    }
}
