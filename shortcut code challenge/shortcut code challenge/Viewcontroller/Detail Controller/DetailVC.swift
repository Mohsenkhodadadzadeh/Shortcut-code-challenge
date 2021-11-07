//
//  DetailVC.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit
import CoreData

class DetailVC: UIViewController {

    @IBOutlet weak var comicImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var comicDetailLabel: UILabel!
    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    
    //MARK: variables for detail image downloader observer
    var _id: Int = 1
    
    var comicData: ComicModel!
    
    fileprivate var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                bookmarkImage.image = UIImage(systemName: "bookmark.fill")
            } else {
                bookmarkImage.image = UIImage(systemName: "bookmark")
            }
        }
    }
    
     var isImageLoaded: Bool = false {
        didSet {
            if isImageLoaded {
                bookmarkImage.isHidden = false
            } else {
                bookmarkImage.isHidden = false
            }
        }
    }
    
     var comicImage: UIImage? {
        didSet {
            if comicImage != nil {
                comicImageView.image = comicImage
            }
        }
    }
    
    fileprivate var managedContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookMarkButtonPress(_ sender: Any) {
        if isImageLoaded {
            bookmark(newStatus: !isFavorite)
        }
    }
    
    @IBAction func shareButtonPress(_ sender: Any) {
        
        if let image = comicImage {
            let item = [image]
            let ac = UIActivityViewController(activityItems: item, applicationActivities: nil)
            if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                ac.popoverPresentationController?.sourceView = self.view
                let w = UIScreen.main.bounds.width
                ac.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: (w / 2) , y: 50), size: CGSize(width: 300, height: 400))
            }
            present(ac, animated: true)
        }
        
    }
    
    private func setupPage() {
        
        self.managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if comicData.image == nil {
            let observableObj: ImageDownloaderObservable = ImageDownloader()
            observableObj.add(object: self)
        }
        loadFavorite()
        
        if let date = comicData.longDate {
            dateLabel.text = "Published on: \(date)"
        } else {
            dateLabel.isHidden = true
        }
        
        comicTitleLabel.text = comicData.safeTitle
        
        comicDetailLabel.text = comicData.description
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        comicImageView.addGestureRecognizer(imageTapGesture)
        
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    fileprivate func loadComicImage() {
        if let url = URL(string: comicData.imageAddress) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.comicImage = UIImage(data: data)
                        
                        self?.isImageLoaded = true
                    }//: DISPATCHQUEUE MAIN
                }
            }//: DISPATCHQUEUE GLOBAL
            
        }
    }
    
    fileprivate func bookmark(newStatus: Bool) {
        let fetch = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
        fetch.predicate = NSPredicate(format:"num == \(comicData.num)")
        
        if newStatus {
            
            let count = try! managedContext.count(for: fetch)
            
            if count > 0 {
                return
            }//: row has been saved before
            
            let entity = NSEntityDescription.entity(forEntityName: "ComicEntity", in: managedContext)!
            let comicEntity = ComicEntity(entity: entity, insertInto: managedContext)
            
            comicEntity.num = Int32(comicData.num)
            comicEntity.title = comicData.title
            comicEntity.comicDescription = comicData.description
            comicEntity.link = comicData.link
            comicEntity.news = comicData.news
            comicEntity.publishedDate = comicData.publishedDate
            comicEntity.safeTitle = comicData.safeTitle
            comicEntity.transcript = comicData.transcript
            let photoData = comicImage?.pngData()
            comicEntity.imageData = photoData
            isFavorite = true
        } else {
            if let object = (try? managedContext.fetch(fetch))?.first {
                managedContext.delete(object)
            }
            isFavorite = false
        }
        try? managedContext.save()
    }
    
    private func loadFavorite() {
        let fetch = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
        fetch.predicate = NSPredicate(format:"num == \(comicData.num)")
        
        if let object = (try? managedContext.fetch(fetch))?.first {
                if let imageData = object.imageData {
                    comicImage = UIImage(data: imageData)
                }
            isFavorite = true
        }//: DATAFETCH OBJECT CHECK
    }
}
