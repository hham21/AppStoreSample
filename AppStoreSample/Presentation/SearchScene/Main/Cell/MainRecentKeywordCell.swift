//
//  MainRecentKeywordCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/03/20.
//

import UIKit
import Reusable

final class MainRecentKeywordCell: UITableViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with data: String) {
        titleLabel.text = data
    }
}
