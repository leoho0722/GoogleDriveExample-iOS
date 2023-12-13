//
//  GoogleDriveViewController.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/18.
//

import UIKit

class GoogleDriveViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    
    
    // MARK: - Properties
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        title = "Google Drive"
        setupNavigationBackButton()
        setupUIBarButtonItem()
    }
    
    fileprivate func setupNavigationBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    fileprivate func setupUIBarButtonItem() {
        let plus = UIBarButtonItem(barButtonSystemItem: .add, 
                                   target: self,
                                   action: #selector(uploadFile(sender:)))
        self.navigationItem.rightBarButtonItem = plus
    }
    
    // MARK: - Function
    

    
    // MARK: - IBAction
    
    @objc private func uploadFile(sender: UIBarButtonItem) {
        if let dir = FileManager.default.urls(for: .documentDirectory,
                                              in: .userDomainMask).first {
            let path = dir.appendingPathComponent("Test.png", conformingTo: .png).path()
            print(path)
            DriveManager.shared.upload(folderName: "/",
                                       filePath: path,
                                       mimeType: "image/png") { result in
                switch result {
                case .success(let identifier):
                    let config = Alert.AlertConfig.confirm(title: "Upload Success",
                                                           message: "File Identifier: \(identifier)",
                                                           confirmTitle: "Confirm",
                                                           confirm: nil)
                    Alert.showAlertWith(vc: self, config: config)
                case .failure(let error):
                    let config = Alert.AlertConfig.confirm(title: "Error",
                                                           message: "\(error)",
                                                           confirmTitle: "Confirm",
                                                           confirm: nil)
                    Alert.showAlertWith(vc: self, config: config)
                }
            }
        }
    }
}

// MARK: - Extensions



// MARK: - Protocol



// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    GoogleDriveViewController()
}

