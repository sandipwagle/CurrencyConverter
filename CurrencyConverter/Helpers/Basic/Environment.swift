//
//  Environment.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation

enum Environment {
    
    static func getAppId() -> String {
        guard let dict = Bundle(for: AppDelegate.self).infoDictionary,
            let appId = dict["App_Id"] as? String else { fatalError("App ID not found in info.plist")
        }
        return appId
    }
    
    private static func getBaseURL() -> String {
        guard let dict = Bundle(for: AppDelegate.self).infoDictionary,
            let urlString = dict["Base_Url"] as? String else { fatalError("Api URL not found in info.plist")
        }
        return urlString
    }
    
    static func getUrl(for endpoint: Constant.Server.EndPoint) -> URL {
        let urlString = getBaseURL() + endpoint.rawValue
        guard let url = URL(string: urlString) else { fatalError("Invalid url")
        }
        return url
    }
    
    static func getApiKey() -> String {
        guard let dict = Bundle(for: AppDelegate.self).infoDictionary,
            let apiKey = dict["Open_Exchange_Api_Key"] as? String else { fatalError("Open Exchange Api Key not found in info.plist")
        }
        return apiKey
    }
    
}
