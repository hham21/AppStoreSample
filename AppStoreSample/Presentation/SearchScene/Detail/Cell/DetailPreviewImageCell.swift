//
//  DetailPreviewImageCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

final class DetailPreviewImageCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var screenShotImageView: UIImageView!
        
    override func prepareForReuse() {
        screenShotImageView.image = nil
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    func setAttributes() {
        screenShotImageView.layer.cornerRadius = 12
        screenShotImageView.layer.borderWidth = 0.2
        screenShotImageView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configure(with urlString: String) {
        screenShotImageView.kf.setImage(with: URL(string: urlString))
    }
}
