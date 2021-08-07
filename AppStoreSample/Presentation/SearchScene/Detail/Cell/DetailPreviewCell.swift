//
//  DetailPreviewCell.swift
//  AppStoreSearch
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Reusable

final class DetailPreviewCell: UITableViewCell, NibReusable {
    struct Const {
        static let cellIdentifier = "DetailPreviewImageCell"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var screenshotURLs: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttributes()
    }
    
    private func setAttributes() {
        configureCollectionView()
        registerCells()
    }
    
    private func registerCells() {
        let identifier: String = Const.cellIdentifier
        let cell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
    }
    
    func configure(with data: Model) {
        screenshotURLs = data.screenshotURLs
    }
}

extension DetailPreviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.cellIdentifier, for: indexPath) as! DetailPreviewImageCell
        let data: String = screenshotURLs[indexPath.row]
        cell.configure(with: data)
        return cell
    }
}

extension DetailPreviewCell: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let width: CGFloat = cellWidth + spacing    // 260
        var offset: CGPoint = targetContentOffset.pointee
        let index: CGFloat = offset.x / width
        var roundedIndex: CGFloat = round(index)
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            if scrollView.contentOffset.x + screenWidth > scrollView.contentSize.width {
                roundedIndex = ceil(index)
            } else {
                roundedIndex = floor(index)
            }
        } else {
            roundedIndex = ceil(index)
        }
        
        offset = CGPoint(x: roundedIndex * width, y: 0)
        targetContentOffset.pointee = offset
    }
}

extension DetailPreviewCell {
    struct Model {
        var screenshotURLs: [String]
    }
}
