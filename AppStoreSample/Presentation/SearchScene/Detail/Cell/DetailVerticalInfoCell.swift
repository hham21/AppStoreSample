//
//  DetailVerticalInfoCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

final class DetailVerticalInfoCell: UITableViewCell, NibReusable {
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!
    @IBOutlet weak var sellerUrlLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    
    private var sellerURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: Model) {
        sellerNameLabel.text = data.sellerName
        fileSizeLabel.text = Int64(data.fileSizeBytes)?.to(unit: .useMB)
        genreLabel.text = data.genre
        sellerUrlLabel.text = data.sellerURL
        
        if let urlString: String = data.sellerURL {
            sellerURL = URL(string: urlString)
        }
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        if let url = sellerURL {
            UIApplication.shared.open(url)
        }
    }
}

extension DetailVerticalInfoCell {
    struct Model {
        var sellerName: String
        var fileSizeBytes: String
        var genre: String
        var contentRating: String
        var sellerURL: String?
    }
}
