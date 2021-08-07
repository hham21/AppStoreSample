//
//  DetailReleaseNotesCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

protocol DetailReleaseNotesCellDelegate: AnyObject {
    func moreButtonTapped(_ cell: UITableViewCell)
}

final class DetailReleaseNotesCell: UITableViewCell, NibReusable {
    struct Const {
        static let defaultHeight: CGFloat = 140.0
    }
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: DetailReleaseNotesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    private func setAttributes() {
        moreButton.backgroundColor = .clear
        moreButton.applyGradient(
            colours: [.init(white: 1.0, alpha: 0.0), .white],
            locations: [0.0, 0.3]
        )
    }
    
    func configure(with data: Model) {
        versionLabel.text = "버전" + data.version
        applyLineSpacing(text: data.releaseNotes)
        releaseDateLabel.text = data.releaseDate.timeAgo()
        
        let width = UIScreen.main.bounds.width - 40.0
        let font = releaseNotesLabel.font!
        let height = data.releaseNotes.height(withConstrainedWidth: width, font: font)
        let originY = releaseNotesLabel.frame.origin.y
        
        if originY + height < Const.defaultHeight || data.collapsed {
            moreButton.isHidden = true
        } else {
            moreButton.isHidden = false
        }
    }
    
    private func applyLineSpacing(text: String) {
        let paragraphStyle: NSMutableParagraphStyle = .init()
        let attributedString: NSMutableAttributedString = .init(string: text)
        let range: NSRange = NSMakeRange(0, attributedString.length)
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: range)
        releaseNotesLabel.attributedText = attributedString
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        moreButton.isHidden = true
        delegate?.moreButtonTapped(self)
    }
}

extension DetailReleaseNotesCell {
    struct Model {
        var releaseNotes: String
        var releaseDate: Date
        var version: String
        var collapsed: Bool = false
    }
}
