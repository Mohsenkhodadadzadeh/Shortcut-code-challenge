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
    
    fileprivate var isImageLoaded: Bool = false {
        didSet {
            if isImageLoaded {
                bookmarkImage.isHidden = false
            } else {
                bookmarkImage.isHidden = false
            }
        }
    }
    
    fileprivate var comicImage: UIImage? {
        didSet {
            if comicImage != nil {
                comicImageView.image = comicImage
            }
        }
    }
    
    fileprivate var managedContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookMarkButtonPress(_ sender: Any) {
        
    }
    
    
    
    
    
    
    
    private func setupPage() {
        
        self.managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadFavorite()
        
        if comicData.image == nil {
            loadComicImage()
        }
        
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
            if comicData == nil {
                var imageObj: UIImage?
                if let imageData = object.imageData {
                    imageObj = UIImage(data: imageData)
                }
                comicData = ComicModel(num: Int(object.num), description: object.description, publishedDate: object.publishedDate ?? Date(), link: object.link ?? "", image: imageObj, news: object.news ?? "", safeTitle: object.safeTitle ?? "", title: object.title ?? "", transcript: object.transcript ?? "")
            }
            isFavorite = true
        }//: DATAFETCH OBJECT CHECK
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
