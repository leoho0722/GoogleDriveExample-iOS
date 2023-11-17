//
//  AuthManager.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/18.
//

import Foundation

import FirebaseAuth
import FirebaseCore
import GoogleAPIClientForREST_Drive
import GoogleSignIn

final class AuthManager: NSObject {
    
    // MARK: - Singleton
    
    static let shared = AuthManager()
    
    // MARK: - Properties
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Method
    
    func signInWithGoogle(vc: UIViewController) async throws {
        // Sign In with Google
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc,
                                                                        hint: nil,
                                                                        additionalScopes: [kGTLRAuthScopeDrive])
        let user = gidSignInResult.user
        guard let idToken = user.idToken else {
            return
        }
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)
        
        UserPreferences.shared.idToken = idToken.tokenString
        UserPreferences.shared.accessToken = accessToken.tokenString
        
        // Firebase Auth
        let signResult = try await Auth.auth().signIn(with: credential)
        print("uid: \(signResult.user.uid)")
        if let email = signResult.user.email,
           let name = signResult.user.displayName {
            print("email: \(email)")
            print("name: \(name)")
        }
        
        // User is sign in
        UserPreferences.shared.isSignIn = true
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        UserPreferences.shared.isSignIn = false
    }
    
    func authStateHandleListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user {
                Task {
                    let idToken = try await user.getIDToken()
                    if idToken != UserPreferences.shared.idToken {
                        UserPreferences.shared.idToken = idToken
                    }
                }
            }
        }
    }
    
    func removeAuthStateHandleListener() {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }
}
