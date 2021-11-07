//
//  Network.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation


public final class Network {
    
    internal let baseURLString: String
    
    internal let session = URLSession.shared
    
    // MARK: - Class Constructors
    public static let shared: Network = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let serviceURLString = dictionary["service_url"] as! String
        let destinationFileString = dictionary["destination_file"] as! String
        let retObj = "\(serviceURLString){0}/\(destinationFileString)"
        return Network(baseURLString: retObj)
    }()
    
    // MARK: - Object Lifecycle
    private init(baseURLString: String) {
      self.baseURLString = baseURLString
    }
    
    func getData<T: Codable>(fileId: Int?, success _success: @escaping(T) -> Void,
                             failure _failure: @escaping(NetworkErrors) -> Void) {
        
        let success: (T) -> Void = { value in
            DispatchQueue.main.async { _success(value) }
        }
        
        let failure: (NetworkErrors) -> Void = { error in
            DispatchQueue.main.async { _failure(error) }
        }
        
        var destinationUrl: URL?
        
        if let fileId = fileId {
            let urlString = baseURLString.replacingOccurrences(of: "{0}", with: "\(fileId)")
            destinationUrl = URL(string: urlString)
        } else {
            let urlString = baseURLString.replacingOccurrences(of: "{0}/", with: "")
            destinationUrl = URL(string: urlString)
        }
        
        guard let strongUrl = destinationUrl else {
            failure(NetworkErrors.nilUrl)
            return
        }
        
        let task = session.dataTask(with: strongUrl) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode.isSuccessHTTPCode, let data = data else {
                if let httpStatusResponse = response as? HTTPURLResponse {
                    switch httpStatusResponse.statusCode {
                        
                    case 200...300: failure(.unknownError(errorDescription: "an error on getting data was accured"))
                        
                    case 404: failure(.notFound)
                    
                    case 500: failure(.internalServerError)
                        
                    default: failure(.unknownError(errorDescription: "unknown status code has been received"))
                        
                    }
                } else {
                    failure(.unknownError(errorDescription: "client cannot get HTTPStatus code"))
                }
                return
            }
            
            let retObj = try! JSONDecoder().decode(T.self, from: data)
                success(retObj)
        }
        
        task.resume()
    }
    
}
