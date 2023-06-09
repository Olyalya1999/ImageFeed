//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Olya on 05.06.2023.
//

import Foundation

final class OAuth2TokenStorage {

    let tokenKey = "BearerToken"
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get{
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
