//
//  ImageDownloader.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

class ImageDownloader: ImageDownloaderObservable {
    private var objects: [ImageDownloaderObserver] = []
    func add(object: ImageDownloaderObserver) {
        if object.id == nil { return }

        if objects.filter({ $0.id == object.id }).isEmpty {
            objects.append(object)
            downloadImage(for: object)
        }
    }
    
    func remove(object: ImageDownloaderObserver) {
        objects = objects.filter { $0.id != object.id }
    }
    
    func update(id: Int, data: UIImage) {
        objects.filter({$0.id == id}).first?.update(image: data)
    }
    
    func downloadImage(for object: ImageDownloaderObserver) {
        
        
        if let url = URL(string: object.imageAddress) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async { [weak self] in
                            self?.update(id: object.id ?? 0, data: image)
                        }//: DISPATCHQUEUE MAIN
                    }
                }
            }//: DISPATCHQUEUE GLOBAL
            
        }
    }
    
    
}
