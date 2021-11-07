//
//  ImageDownloaderObserver.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation
import UIKit

protocol ImageDownloaderObserver {
    var id: Int? { get }
    var imageAddress: String {get}
    func update(image: UIImage)
}
