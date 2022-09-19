//
//  Constants.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation

enum Constant {
    
    enum Alert: String, AlertActionable {
        case ok
        
        var title: String { rawValue }
        
        var destructive: Bool { false }
    }
    
    enum Database {
        public static let dataModel = "CurrencyConverter"
    }
    
    enum UserDefaultKeys: String {
        case lastFetchDate
    }
    
    enum Server {
        
        enum EndPoint: String {
            case latestJson = "latest.json"
            case currencies = "currencies.json"
            case getAuthenticatedUser = "GetAuthenticatedUser"
            case refreshToken = "RefreshToken"
        }
        
        enum ParamKey: String {
            case Key
            case musicId
            case bio
            case isActiveIntro
        }
        
        enum Credential {
            static let apiKey = "AccessTokenKey"
        }

    }
    
}
