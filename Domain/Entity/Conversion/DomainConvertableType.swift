//
//  DomainConvertableType.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Foundation

public protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}
