//
//  UIViewController.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

// MARK: - Making UIviewController confirms to presentable
extension UIViewController: Presentable, UIAdaptivePresentationControllerDelegate {
    public var presenting: UIViewController? {
        return self
    }
}
