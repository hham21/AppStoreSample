//
//  RMKeyword.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RealmSwift

final class RMKeyword: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return #keyPath(RMKeyword.text)
    }
}

extension RMKeyword: DomainConvertibleType {
    func asDomain() -> Keyword {
        return Keyword(text: text, date: date)
    }
}

extension Keyword: RealmConvertableType {
    func asRealm() -> RMKeyword {
        let keyword = RMKeyword()
        keyword.text = text
        keyword.date = date
        return keyword
    }
}
