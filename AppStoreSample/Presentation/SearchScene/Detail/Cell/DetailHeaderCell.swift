//
//  DetailHeaderCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

final class DetailHeaderCell: UITableViewCell, NibReusable {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
        
    override func prepareForReuse() {
        mainImageView.image = nil
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    private func setAttributes() {
        mainImageView.layer.cornerRadius = 12.0
        mainImageView.layer.borderWidth = 0.2
        mainImageView.layer.borderColor = UIColor.systemGray.cgColor
        openButton.layer.cornerRadius = openButton.frame.height / 2
    }
    
    func configure(with data: Model) {
        mainImageView.kf.setImage(with: URL(string: data.artWorkURL))
        mainTitleLabel.text = data.trackName
        subtitleLabel.text = data.sellerName
    }
}

extension DetailHeaderCell {
    struct Model {
        var artWorkURL: String
        var trackName: String
        var sellerName: String
    }
}
