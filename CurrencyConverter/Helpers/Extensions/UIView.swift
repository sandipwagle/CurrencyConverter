//
//  UIView.swift
//  CurrencyConverter
//
//  Created by ebpearls on 27/08/2022.
//

import UIKit

extension UIView {
    
    func maskTop(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func addGradient(_ colors: [UIColor], locations: [NSNumber], frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.locations = locations
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
