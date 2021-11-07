//
//  DetailImageDownloader.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

extension DetailVC: ImageDownloaderObserver {
    var id: Int? {
        get {
            return _id
        }
        
    }
    
    var imageAddress: String {
        get {
            return comicData.imageAddress
        }
        
    }
    
    func update(image: UIImage) {
            comicImage = image
            isImageLoaded = true
    }
    
    
}
