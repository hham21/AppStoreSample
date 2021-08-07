//
//  DetailDescriptionCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

protocol DetailDescriptionCellDelegate: AnyObject {
    func moreButtonTapped(_ cell: UITableViewCell)
}

final class DetailDescriptionCell: UITableViewCell, NibReusable {
    struct Const {
        static let defaultHeight: CGFloat = 116.0
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: DetailDescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    private func setAttributes() {
        moreButton.backgroundColor = .clear
        moreButton.applyGradient(
            colours: [.init(white: 1.0, alpha: 0.0), .white],
            locations: [0.0, 0.3])
    }
    
    func configure(with data: Model) {
        applyLineSpacingToDescriptionLabel(text: data.description)
        
        let width = UIScreen.main.bounds.width - 40.0
        let font = descriptionLabel.font!
        let height = data.description.height(withConstrainedWidth: width, font: font)
        let originY = descriptionLabel.frame.origin.y
        
        if originY + height < Const.defaultHeight || data.collapsed {
            moreButton.isHidden = true
        } else {
            moreButton.isHidden = false
        }
    }
    
    private func applyLineSpacingToDescriptionLabel(text: String) {
        let paragraphStyle: NSMutableParagraphStyle = .init()
        let attributedString: NSMutableAttributedString = .init(string: text)
        let range: NSRange = NSMakeRange(0, attributedString.length)
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: range)
        descriptionLabel.attributedText = attributedString
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreButton.isHidden = true
        delegate?.moreButtonTapped(self)
    }
}

extension DetailDescriptionCell {
    struct Model {
        var description: String
        var collapsed: Bool = false
    }
}
