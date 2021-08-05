//
//  DBObjectConvertableType.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/04.
//

import Domain

protocol DBObjectConvertableType {
    associatedtype DBObjectType: DomainConvertibleType

    func asDBObject() -> DBObjectType
}

