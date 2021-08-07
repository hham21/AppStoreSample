//
//  DetailHorizontalInfoCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable
import Cosmos

final class DetailHorizontalInfoCell: UITableViewCell, NibReusable {
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var languageCodeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
    }

    private func layoutViews() {
        ratingView.addSubview(cosmosView)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        
        cosmosView
            .leftAnchor
            .constraint(equalTo: ratingView.leftAnchor)
            .isActive = true
        cosmosView
            .rightAnchor
            .constraint(equalTo: ratingView.rightAnchor)
            .isActive = true
        cosmosView
            .topAnchor
            .constraint(equalTo: ratingView.topAnchor)
            .isActive = true
        cosmosView
            .bottomAnchor
            .constraint(equalTo: ratingView.bottomAnchor)
            .isActive = true
    }
    
    func configure(with data: Model) {
        let code: String = data.languageCode
        let locale: Locale = .init(identifier: "KO")
        
        ratingCountLabel.text = makeEvaluationString(data.ratingCount)
        ratingLabel.text = String(round(10 * data.rating) / 10)
        contentRatingLabel.text = data.contentRating
        artistNameLabel.text = data.artistName
        languageCodeLabel.text = code
        languageLabel.text = locale.localizedString(forLanguageCode: code)
        
        cosmosView.rating = data.rating
        
        if data.rating == 0 || data.ratingCount == 0 {
            cosmosView.isHidden = true
        } else {
            cosmosView.isHidden = false
        }
    }
    
    func makeEvaluationString(_ count: Int) -> String {
        if count > 10000 {
            let num: Double = round(10 * Double(count) / 10000) / 10
            let numString: String = num.isInteger ? String(Int(num)) : String(num)
            return numString + "만개의 평가"
        }
        
        if count > 1000 {
            let num: Double = round(10 * Double(count) / 1000) / 10
            let numString: String = num.isInteger ? String(Int(num)) : String(num)
            return numString + "천개의 평가"
        }
        
        return String(count) + "개의 평가"
    }
}

extension DetailHorizontalInfoCell {
    struct Model {
        var ratingCount: Int
        var rating: Double
        var contentRating: String
        var artistName: String
        var languageCode: String
    }
}
