//
//  BaseNavigationController.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    public init(appearance: UINavigationBarAppearance) {
        UINavigationBar.appearance().standardAppearance = appearance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class is not meant to be initialized by coder")
    }
    
    deinit {
        debugPrint("De-Initialized Navigation Controller --> \(String(describing: self))")
    }
}
