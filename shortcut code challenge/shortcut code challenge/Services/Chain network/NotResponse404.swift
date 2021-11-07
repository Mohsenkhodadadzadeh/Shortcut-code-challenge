//
//  NotResponse404.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation
/**
 or we can show 404 page immediately instead of throw exception
 with some code like following :
 ~~~
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 if let destPage = storyboard.instantiateViewController(withIdentifier: "Page404") as? Page404 {
     
     if #available(iOS 13, *) {
        destPage.modalPresentationStyle = .fullScreen
     }
     UIWindow.getTopViewController()?.present(destPage, animated: true, completion: nil)
 ~~~
 }
 */
class NotResponse404: NetworkChainProtocol {
    func calculate<T: Codable>(_ unserilized: Data, status: Int) throws -> T {
        if status == 404 {
            throw(NetworkErrors.notFound)
            
        } else {
            if next != nil {
                return try next!.calculate(unserilized, status: status)
            }
            throw(NetworkErrors.endOfChain)
        }
    }
    var next: NetworkChainProtocol?
}
