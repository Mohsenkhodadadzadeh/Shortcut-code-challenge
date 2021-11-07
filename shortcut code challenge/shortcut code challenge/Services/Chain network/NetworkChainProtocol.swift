//
//  NetworkChainProtocol.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation

protocol NetworkChainProtocol {

    func calculate <T: Codable>(_ unserilized: Data, status: Int) throws -> T
    var next: NetworkChainProtocol? { get set}
}
