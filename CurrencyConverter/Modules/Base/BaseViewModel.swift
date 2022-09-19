//
//  BaseViewModel.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import Foundation
import Combine

/// protocol for app route
protocol AppRoutable {}

protocol BaseViewModelProtocol {
    var bag: Set<AnyCancellable> { get set }
    var trigger: PassthroughSubject<AppRoutable, Never> { get set }
}

/// The baseViewModel for every viewModel
class BaseViewModel: BaseViewModelProtocol {

    /// The subcription cleanup bag
    var bag: Set<AnyCancellable>

    /// Routes trigger
    var trigger: PassthroughSubject<AppRoutable, Never>
    
    /// The initializer
    init() {
        self.bag = Set<AnyCancellable>()
        self.trigger = PassthroughSubject<AppRoutable, Never>()
    }
    
    deinit {
        debugPrint("De-Initialized ViewModel --> \(String(describing: self))")
    }
}
