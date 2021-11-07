//
//  ServerError500.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation

/**
 or we can show internal server error page immediately instead of throw exception
 with some code like following :
 ~~~
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 if let destPage = storyboard.instantiateViewController(withIdentifier: "Page500") as? Page500 {
     
     if #available(iOS 13, *) {
        destPage.modalPresentationStyle = .fullScreen
     }
     UIWindow.getTopViewController()?.present(destPage, animated: true, completion: nil)
 ~~~
 }
 */
class ServerError500: NetworkChainProtocol {
    func calculate<T: Codable>(_ unserilized: Data, status: Int) throws -> T {
        if status == 500 {
            throw(NetworkErrors.internalServerError)
        } else {
            if next != nil {
                return try next!.calculate(unserilized, status: status)
            }
            throw(NetworkErrors.endOfChain)
        }
    }
    var next: NetworkChainProtocol?
}
