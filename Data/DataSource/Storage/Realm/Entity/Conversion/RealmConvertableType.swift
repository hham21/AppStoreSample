//
//  RealmConvertableType.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain

protocol RealmConvertableType {
    associatedtype RealmType: DomainConvertibleType

    var id: String { get }

    func asRealm() -> RealmType
}
