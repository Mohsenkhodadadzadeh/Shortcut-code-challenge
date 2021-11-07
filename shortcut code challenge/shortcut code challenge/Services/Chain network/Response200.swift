//
//  Response200.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation

class Response200: NetworkChainProtocol {
    func calculate<T: Codable>(_ unserilized: Data, status: Int) throws -> T {

        if status == 200 {
            let retObj = try! JSONDecoder().decode(T.self, from: unserilized)
            return retObj
        } else {
            if next != nil {
                return try next!.calculate(unserilized, status: status)
            }
            throw(NetworkErrors.endOfChain)
        }
    }
    var next: NetworkChainProtocol?
}
