//
//  SearchTrackCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/03/21.
//

import UIKit
import Reusable
import Cosmos
import Kingfisher

protocol SearchTrackCellDelegate: AnyObject {
    func openButtonTapped(cell: SearchTrackCell)
}

final class SearchTrackCell: UITableViewCell, NibReusable {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet var imageViews: [UIImageView]!
    
    weak var delegate: SearchTrackCellDelegate?
    
    private lazy var cosmosView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.starMargin = 0.0
        cosmosView.settings.starSize = 14.0
        cosmosView.settings.textColor = .gray
        cosmosView.settings.filledColor = .gray
        cosmosView.settings.emptyBorderColor = .gray
        cosmosView.settings.filledBorderColor = .gray
        return cosmosView
    }()
    
    override func prepareForReuse() {
        cosmosView.prepareForReuse()
        artworkImageView.image = nil
        imageViews.forEach { $0.image = nil }
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
        layoutViews()
    }
    
    private func setAttributes() {
        for imageView in imageViews {
            imageView.layer.cornerRadius = 12
            imageView.layer.borderWidth = 0.2
            imageView.layer.borderColor = UIColor.systemGray.cgColor
        }

        artworkImageView.layer.cornerRadius = 12
        artworkImageView.layer.borderWidth = 0.2
        artworkImageView.layer.borderColor = UIColor.systemGray.cgColor
        
        openButton.layer.cornerRadius = openButton.frame.height / 2
    }
    
    private func layoutViews() {
        ratingView.addSubview(cosmosView)
    }
    
    func configure(with data: Model) {
        titleLabel.text = data.trackName
        subtitleLabel.text = data.sellerName
        configureImageViews(with: data)
        configureRatingView(with: data)
    }
    
    private func configureImageViews(with data: Model) {
        artworkImageView.kf.setImage(with: URL(string: data.artworkURL!))
        for idx in 0...2 {
            if data.screenshotURLs.indices.contains(idx) {
                let imageURL = data.screenshotURLs[idx]
                imageViews[idx].kf.setImage(with: URL(string: imageURL))
                imageViews[idx].isHidden = false
            } else {
                imageViews[idx].isHidden = true
            }
        }
    }
    
    private func configureRatingView(with data: Model) {
        cosmosView.rating = data.rating
        cosmosView.text = makeEvaluationString(data.ratingCount)
        
        if data.rating == 0 || data.ratingCount == 0 {
            cosmosView.isHidden = true
        } else {
            cosmosView.isHidden = false
        }
    }
    
    private func makeEvaluationString(_ count: Int) -> String {
        if count > 10000 {
            // Decimal point to 1
            // 10 * 12345 / 10000 = 12.345
            // round(12.345) = 12
            // 12 / 10 = 1.2
            // 10 은 decimal point
            // 10000 은 자리수
            let num = round(10 * Double(count) / 10000) / 10
            if num.isInteger {
                return String(Int(num)) + "만"
            } else {
                return String(num) + "만"
            }
        }
        
        if count > 1000 {
            let num = round(10 * Double(count) / 1000) / 10
            if num.isInteger {
                return String(Int(num)) + "천"
            } else {
                return String(num) + "천"
            }
        }
        
        return String(count)
    }
    
    private func setImageViewCommonAttributes(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    @IBAction func openButtonTapped(_ sender: UIButton) {
        delegate?.openButtonTapped(cell: self)
    }
}

extension SearchTrackCell {
    struct Model {
        let trackId: Int
        let trackName: String
        let sellerName: String
        let screenshotURLs: [String]
        let artworkURL: String?
        let rating: Double
        let ratingCount: Int
    }
}
