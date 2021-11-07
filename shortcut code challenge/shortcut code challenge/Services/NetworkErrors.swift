//
//  NetworkErrors.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation

enum NetworkErrors: Error {
    case notFound
    case internalServerError
    case nilUrl
    case endOfChain
    case convertToModelError(id: Int?)
    case unknownError(errorDescription: String?)
    
}

extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {

        case .notFound: return "URL Not found"

        case .internalServerError: return "An error accures on the server"
    
        case .nilUrl: return "Url was received nil"
            
        case .endOfChain: return "Undifined error"
        
        case .convertToModelError(let id): return "convert data to model failed for \(id == nil ? " last object": "\(id!) object")"
            
        case .unknownError(let errorDescription): return "new error was occured in line \(#line) , Network->\(#function): \(String(describing: errorDescription))"
            

        }
    }
}
