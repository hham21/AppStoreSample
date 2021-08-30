//
//  SettingModel.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxDataSources

// MARK: - Setting

struct SettingMain {
    typealias Model = SectionModel<Section, Item>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Model>
    
    enum Section {
        case misc
        case account
    }
    
    enum Item {
        case push(Destination)
        case logout
        
        var title: String {
            switch self {
            case .push(let destination):
                switch destination {
                case .internal:
                    return "Internal"
                }
            case .logout:
                return "Logout"
            }
        }
    }
    
    enum Destination {
        case `internal`
    }
    
    func buildModel(_ setting: Setting) -> [Model] {
        [
            buildMiscData(with: setting),
            buildAccountData()
        ]
    }
    
    private func buildMiscData(with setting: Setting) -> Model {
        var items: [Item] = .init()
        
        if setting.isInternalMode {
            items.append(.push(.internal))
        }
        
        return .init(model: .misc, items: items)
    }
    
    private func buildAccountData() -> Model {
        .init(model: .account, items: [.logout])
    }
}
