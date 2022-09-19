//
//  JsonConvertible.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation

protocol JsonConvertible {}

extension JsonConvertible {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let childValue = child.value as? JsonConvertible {
                    dict[key] = childValue.toDict()
                } else {
                    dict[key] = child.value
                }
            }
        }
        return dict
    }
}
