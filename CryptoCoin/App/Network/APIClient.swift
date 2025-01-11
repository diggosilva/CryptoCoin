//
//  APIClient.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//
import Foundation

class APIClient {
    static let apiUSA = Bundle.main.object(forInfoDictionaryKey: "ApiUrlUS") as! String
    static let apiBRA = Bundle.main.object(forInfoDictionaryKey: "ApiUrlBR") as! String
    
    static func getURL() -> String {
        let language = Locale.current.language.languageCode ?? "en"
        
        if language == "pt" {
            return Bundle.main.object(forInfoDictionaryKey: "ApiUrlBR") as! String
        } else {
            return Bundle.main.object(forInfoDictionaryKey: "ApiUrlUS") as! String
        }
    }
}
