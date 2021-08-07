//
//  UIView+Ext.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = .init(x: 0.0, y: 0.5)
        gradient.endPoint = .init(x: 1.0, y: 0.5)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
