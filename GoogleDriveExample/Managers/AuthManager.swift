//
//  AuthManager.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/18.
//

import Foundation
import GoogleAPIClientForREST_Drive
import GoogleSignIn

final class AuthManager: NSObject {
    
    // MARK: - Singleton
    
    static let shared = AuthManager()
    
    // MARK: - Properties
    
    
    
    // MARK: - Method
    
    func signInWithGoogle(vc: UIViewController) async throws {
        // Sign In with Google
        guard !AppDefine.gidClientID.isEmpty else {
            fatalError("GIDClientID is empty string")
        }
        let config = GIDConfiguration(clientID: AppDefine.gidClientID)
        GIDSignIn.sharedInstance.configuration = config
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc,
                                                                        hint: nil,
                                                                        additionalScopes: [kGTLRAuthScopeDrive])
        let user = gidSignInResult.user
        guard let idToken = user.idToken else {
            return
        }
        let accessToken = user.accessToken
        
        UserPreferences.shared.idToken = idToken.tokenString
        UserPreferences.shared.accessToken = accessToken.tokenString
        
        // User is sign in
        UserPreferences.shared.isSignIn = true
    }
}
