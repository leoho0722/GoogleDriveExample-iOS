//
//  GTLRDriveService+Extensions.swift
//  GoogleDriveExample
//
//  Created by Leo Ho on 2023/11/18.
//

import Foundation

import GoogleAPIClientForREST_Drive

extension GTLRDriveService {
    
    func executeQuery(_ query: GTLRQueryProtocol,
                      completionHandler handler: @escaping (Result<(ticket: GTLRServiceTicket, results: Any?), Error>) -> Void) {
        executeQuery(query) { ticket, results, error in
            if error != nil {
                handler(.failure(error!))
            } else {
                handler(.success((ticket, results)))
            }
        }
    }
}
