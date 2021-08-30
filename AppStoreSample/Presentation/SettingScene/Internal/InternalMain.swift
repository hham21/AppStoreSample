//
//  InternalMain.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import Foundation
import RxDataSources

// MARK: - Internal

struct InternalMain {
    typealias Model = SectionModel<Section, Item>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Model>
    
    enum Section {
        case first
    }
    
    enum Item {
        case isLoggingToFileEnabled(Bool)
        case shareLogFile
        
        var title: String {
            switch self {
            case .isLoggingToFileEnabled(_):
                return "Save Log file to disk"
            case .shareLogFile:
                return "Share Log file"
            }
        }
    }
    
    func buildModel(isLoggingToFileEnabled: Bool) -> [Model] {
        [
            .init(model: .first, items: [
                .isLoggingToFileEnabled(isLoggingToFileEnabled),
                .shareLogFile
            ])
        ]
    }
}

enum InternalMainError: Error, LocalizedError {
    case noLogFile
    
    var errorDescription: String? {
        switch self {
        case .noLogFile:
            return "No Log file!!!"
        }
    }
}
