//
//  UINavigationBarAppearance.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

extension UINavigationBarAppearance {
    
    static func getAppNavigationBarAppearance() -> UINavigationBarAppearance {
        
        let largeFont = UIFont.systemFont(ofSize: 27)
        let smallFont = UIFont.systemFont(ofSize: 16)

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: smallFont]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: largeFont]
        return navigationBarAppearance
    }
    
}
