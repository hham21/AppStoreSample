//
//  Data+JSON.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

import Foundation
import XCTest

extension Data {
    public static func fromJSON(fileName: String, file: StaticString = #file, line: UInt = #line) throws -> Data {
        let bundle: Bundle = .init(for: TestBundleClass.self)
        let url = try XCTUnwrap(
            bundle.url(forResource: fileName, withExtension: "json"),
            "Unable to find \(fileName).json.",
            file: file,
            line: line
        )
        return try Data(contentsOf: url)
    }
}

private class TestBundleClass {}

