//
//  RMSetting.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RealmSwift

final class RMSetting: Object {
    @objc dynamic var isInternalMode: Bool = false
    @objc dynamic var uuid: UUID = .init()
    
    override class func primaryKey() -> String? {
        return #keyPath(RMSetting.uuid)
    }
}

extension RMSetting: DomainConvertibleType {
    func asDomain() -> Setting {
        return Setting(isInternalMode: isInternalMode)
    }
}

extension Setting: RealmConvertableType {
    func asRealm() -> RMSetting {
        let setting = RMSetting()
        setting.isInternalMode = isInternalMode
        return setting
    }
}
