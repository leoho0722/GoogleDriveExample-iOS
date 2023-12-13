//
//  DriveManager.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/18.
//

import Foundation

import GoogleAPIClientForREST_Drive

final class DriveManager: NSObject {
    
    static let shared = DriveManager()
    
    private let service = GTLRDriveService()
    
    private override init() {
        guard !AppDefine.googleDriveApiKey.isEmpty else {
            fatalError("Google Drive API Key is empty string")
        }
        guard !AppDefine.bundleID.isEmpty else {
            fatalError("Bundle ID is empty string")
        }
        service.apiKey = AppDefine.googleDriveApiKey
        service.apiKeyRestrictionBundleID = AppDefine.bundleID
    }
    
    func upload(folderName: String,
                filePath: String,
                mimeType: String,
                finish: @escaping (Result<String, Error>) -> Void) {
        search(filename: folderName) { [unowned self] result in
            switch result {
            case .success(let identifier):
                uploadFile(parentID: identifier,
                           path: filePath,
                           mimeType: mimeType) { result in
                    switch result {
                    case .success(let identifier):
                        finish(.success(identifier))
                    case .failure(let error):
                        finish(.failure(error))
                    }
                }
            case .failure(let error):
                finish(.failure(error))
            }
        }
    }
    
    func search(filename: String, finish: @escaping (Result<String, Error>) -> Void) {
        let query = GTLRDriveQuery_FilesList.query()
        query.q = "name contains '\(filename)'"
        
        service.executeQuery(query) { result in
            switch result {
            case .success(let success):
                if let fileList = success.results as? GTLRDrive_FileList,
                   let file = fileList.files?.first,
                   let identifier = file.identifier {
                    finish(.success(identifier))
                }
            case .failure(let error):
                finish(.failure(error))
            }
        }
    }
    
    func delete(fileID: String, finish: @escaping (Result<Bool, Error>) -> Void) {
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: fileID)
        service.executeQuery(query) { result in
            switch result {
            case .success(_):
                finish(.success(true))
            case .failure(let error):
                finish(.failure(error))
            }
        }
    }
    
    func download(fileID: String, finish: @escaping (Result<Data, Error>) -> Void) {
            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { result in
            switch result {
            case .success(let success):
                if let file = success.results as? GTLRDataObject {
                    finish(.success(file.data))
                }
            case .failure(let error):
                finish(.failure(error))
            }
        }
    }
}

extension DriveManager {
    
    enum DriveError: Error {
        
        case noDataAtPath
    }
}

private extension DriveManager {
    
    func uploadFile(parentID: String,
                    path: String,
                    mimeType: String,
                    finish: @escaping (Result<String, Error>) -> Void) {
        guard let data = FileManager.default.contents(atPath: path) else {
            finish(.failure(DriveError.noDataAtPath))
            return
        }
        
        let file = GTLRDrive_File()
        file.name = path.components(separatedBy: "/").last
        file.parents = [parentID]
        
        let uploadParams = GTLRUploadParameters(data: data, mimeType: mimeType)
        uploadParams.shouldUploadWithSingleRequest = true
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
        query.fields = "id"
        
        service.executeQuery(query) { result in
            switch result {
            case .success(let success):
                if let file = success.results as? GTLRDrive_File,
                   let identifier = file.identifier {
                    finish(.success(identifier))
                }
            case .failure(let error):
                finish(.failure(error))
            }
        }
    }
}

/*
 Reference:
 1. https://agostini.tech/2018/04/22/using-google-drive-in-your-app/
 2. https://github.com/agostini-tech/ATGoogleDriveDemo
 3. https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
 */
