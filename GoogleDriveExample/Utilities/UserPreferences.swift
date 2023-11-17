//
//  UserPreferences.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/17.
//

import Foundation

final class UserPreferences: NSObject {
    
    static let shared = UserPreferences()
    
    private let userDefaults = UserDefaults()
    
    enum Keys: String {
        
        case idToken
        
        case accessToken
        
        case isSignIn
    }
    
    var idToken: String {
        get { userDefaults.string(forKey: Keys.idToken.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.idToken.rawValue) }
    }
    
    var accessToken: String {
        get { userDefaults.string(forKey: Keys.accessToken.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.accessToken.rawValue) }
    }
    
    var isSignIn: Bool {
        get { userDefaults.bool(forKey: Keys.isSignIn.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.isSignIn.rawValue) }
    }
}
