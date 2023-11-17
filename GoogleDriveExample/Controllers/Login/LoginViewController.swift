//
//  LoginViewController.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/17.
//

import UIKit
import GoogleSignIn

class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var btnSignInWithGoogle: GIDSignInButton!
    
    // MARK: - Properties
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthManager.shared.authStateHandleListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeAuthStateHandleListener()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        title = "Login"
        setupGIDSignInButton()
    }
    
    fileprivate func setupGIDSignInButton() {
        btnSignInWithGoogle.colorScheme = .dark
    }
    
    // MARK: - Function

    

    // MARK: - IBAction
    
    @IBAction func btnSignInWithGoogleClick(_ sender: GIDSignInButton) {
        Task {
            do {
                try await AuthManager.shared.signInWithGoogle(vc: self)
                
                let nextVC = GoogleDriveViewController()
                self.pushViewController(nextVC)
            } catch {
                let config = Alert.AlertConfig.confirm(title: "Error",
                                                       message: error.localizedDescription,
                                                       confirmTitle: "Confirm",
                                                       confirm: nil)
                Alert.showAlertWith(vc: self, config: config)
            }
        }
    }
    
}

// MARK: - Extensions



// MARK: - Protocol



// MARK: - Previews

//@available(iOS 17.0, *)
//#Preview {
//    LoginViewController()
//}
