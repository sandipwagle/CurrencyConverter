//
//  UserDefault.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let name: Constant.UserDefaultKeys
    let defaultValue: T
    
    let container: UserDefaults
    
    init(name: Constant.UserDefaultKeys,  defaultValue: T, container: UserDefaults = UserDefaults.standard) {
        self.name = name
        self.defaultValue = defaultValue
        self.container = container
    }
    
    var wrappedValue: T {
        get {
            container.value(forKey: name.rawValue) as? T ?? defaultValue
        }
        
        set {
            container.setValue(newValue, forKey: name.rawValue)
        }
    }
    
}
