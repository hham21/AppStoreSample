//
//  MainHeaderCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/03/20.
//

import UIKit
import Reusable

final class MainHeaderCell: UITableViewCell, NibReusable {
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    private func setAttributes() {
        isUserInteractionEnabled = false
    }    
}

