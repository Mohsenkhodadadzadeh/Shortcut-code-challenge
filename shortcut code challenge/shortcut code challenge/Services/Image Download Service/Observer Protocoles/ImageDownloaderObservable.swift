//
//  ImageDownloaderObservable.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//


import UIKit

protocol ImageDownloaderObservable {
    func add(object: ImageDownloaderObserver)
    func remove(object: ImageDownloaderObserver)
    func update(id: Int, data: UIImage)
}
