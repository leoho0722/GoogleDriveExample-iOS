//
//  AppDefine.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/12/13.
//

import Foundation

struct AppDefine {
    
    /// Google Cloud 上的 OAuth 2.0 Client ID
    static var gidClientID: String {
        guard let clientID = Bundle.main.infoDictionary?["GIDClientID"] as? String else {
            return ""
        }
        print("GIDClientID：",clientID)
        return clientID
    }
    
    /// Google Cloud 上新增的 Google Drive API Key
    static var googleDriveApiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["GoogleDriveAPI_KEY"] as? String else {
            return ""
        }
        print("Google Drive API Key：",apiKey)
        return apiKey
    }

    static var bundleID: String {
        guard let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            return ""
        }
        print("Bundle ID：",bundleID)
        return bundleID
    }
}
