//
//  FavoriteVC.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data: [ComicModel] = []
    
    var selectedComic: ComicModel!
    
     var managedContext : NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            if let destNav = segue.destination as? DetailVC {
                destNav.comicData = selectedComic
            }
        }
    }

    fileprivate func loadData() {
        let fetch = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
        fetch.predicate = NSPredicate(format:"num > -1")
        
        if let fetchData = try? managedContext.fetch(fetch) {
            data = []
            for item in fetchData {
                var image: UIImage?
                if let imageData = item.imageData {
                    image = UIImage(data: imageData)
                }
                let dbData: ComicModel = ComicModel(num: Int(item.num), description: item.comicDescription ?? "" , publishedDate: item.publishedDate ?? Date(), link: item.link ?? "", image: image, news: item.news ?? "", safeTitle: item.safeTitle ?? "", title: item.title ?? "", transcript: item.transcript ?? "")
                data.append(dbData)
            }
            tableView.reloadData()
        }
    }
    
}
