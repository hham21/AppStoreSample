//
//  SearchDetailModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import Domain
import RxDataSources

struct SearchDetail {
    typealias Model = SectionModel<DetailViewSection, DetailViewItem>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Model>

    enum DetailViewSection {
        case none
    }

    enum DetailViewItem {
        case header(DetailHeaderCell.Model)
        case horizaontalInfo(DetailHorizontalInfoCell.Model)
        case releaseNotes(DetailReleaseNotesCell.Model)
        case preview(DetailPreviewCell.Model)
        case description(DetailDescriptionCell.Model)
        case sellerInfo(DetailSellerInfoCell.Model)
        case verticalInfo(DetailVerticalInfoCell.Model)
    }

    struct DetailViewItemModel {
        func parse(data: Track) -> [DetailViewItem] {
            var items: [DetailViewItem] = .init()
            items.append(buildHeaderCellItem(with: data))
            items.append(buildHorizontalInfoCellItem(with: data))
            items.append(buildReleaseNotesCellItem(with: data))
            items.append(buildPreviewCellItem(with: data))
            items.append(buildDescriptionCellItem(with: data))
            items.append(buildSellerInfoCellItem(with: data))
            items.append(buildVerticalInfoCellItem(with: data))
            return items
        }
        
        private func buildHeaderCellItem(with data: Track) -> DetailViewItem {
            let cellModel: DetailHeaderCell.Model = .init(
                artWorkURL: data.artworkURL ?? "",
                trackName: data.trackName,
                sellerName: data.sellerName
            )
            return .header(cellModel)
        }
        
        private func buildHorizontalInfoCellItem(with data: Track) -> DetailViewItem {
            let cellModel: DetailHorizontalInfoCell.Model = .init(
                ratingCount: data.ratingCount ?? 0,
                rating: data.rating ?? 0.0,
                contentRating: data.contentRating,
                artistName: data.artistName,
                languageCode: data.languageCodes.first ?? ""
            )
            return .horizaontalInfo(cellModel)
        }
        
        private func buildReleaseNotesCellItem(with data: Track) -> DetailViewItem {
            let cellModel: DetailReleaseNotesCell.Model = .init(
                releaseNotes: data.releaseNotes ?? "",
                releaseDate: data.releaseDate ?? Date(),
                version: data.version ?? ""
            )
            return .releaseNotes(cellModel)
        }
        
        private func buildPreviewCellItem(with data: Track) -> DetailViewItem {
            .preview(.init(screenshotURLs: data.screenshotURLs))
        }
        
        private func buildDescriptionCellItem(with data: Track) -> DetailViewItem {
            .description(.init(description: data.description ?? ""))
        }
        
        private func buildSellerInfoCellItem(with data: Track) -> DetailViewItem {
            .sellerInfo(.init(sellerName: data.sellerName))
        }
        
        private func buildVerticalInfoCellItem(with data: Track) -> DetailViewItem {
            let cellModel: DetailVerticalInfoCell.Model = .init(
                sellerName: data.sellerName,
                fileSizeBytes: data.fileSizeBytes ?? "",
                genre: data.genres.first ?? "",
                contentRating: data.contentRating,
                sellerURL: data.sellerURL
            )
            return .verticalInfo(cellModel)
        }
    }

}
