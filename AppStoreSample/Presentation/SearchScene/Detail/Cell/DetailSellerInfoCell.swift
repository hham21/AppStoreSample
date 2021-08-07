//
//  DetailSellerInfoCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

final class DetailSellerInfoCell: UITableViewCell, NibReusable {
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: Model) {
        sellerNameLabel.text = data.sellerName
    }
}

extension DetailSellerInfoCell {
    struct Model {
        var sellerName: String
    }
}
