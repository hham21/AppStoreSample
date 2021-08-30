//
//  SettingRealmDataSource.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift
import RealmSwift

public struct SettingRealmDataSource: SettingDataSource {
    public init() {}
    
    public func getSetting() -> Single<Setting> {
        .create { observer in
            do {
                let realm = try Realm(of: RMSetting.self)
                let objects = realm.objects(RMSetting.self)
                
                if let setting = Array(objects).last {
                    observer(.success(setting.asDomain()))
                } else {
                    let setting = Setting()
                    let rmSetting = setting.asRealm()
                    
                    try realm.write {
                        realm.add(rmSetting)
                        observer(.success(setting))
                    }
                }
            } catch {
                dump(error)
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func saveSetting(_ setting: Setting) -> Completable {
        .create { observer in
            do {
                let realm = try Realm(of: RMSetting.self)
                
                //
                
                let objects = realm.objects(RMSetting.self)
                
                if objects.count > 0 {
                    let semaphore = DispatchSemaphore(value: 0)
                    
                    try realm.write {
                        realm.delete(objects)
                        semaphore.signal()
                    }
                    
                    semaphore.wait()
                }
                
                //
                
                let rmSetting = setting.asRealm()
                
                let semaphore = DispatchSemaphore(value: 0)
                
                try realm.write {
                    realm.add(rmSetting)
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                observer(.completed)
            } catch {
                dump(error)
                observer(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func observeSetting() -> Observable<Void> {
        return .create { observer in
            do {
                let realm = try Realm(of: RMSetting.self)
                
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
    }
}
