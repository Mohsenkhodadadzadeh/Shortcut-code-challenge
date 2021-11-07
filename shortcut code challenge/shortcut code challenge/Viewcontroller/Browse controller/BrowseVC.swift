//
//  BrowseVC.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

class BrowseVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var latestReceiveId: Int = -1
    
    var comicBunchCount: Int = 20
    
    var comicLoadedCount: Int = 0
    
    var isSearchTextFieldEmpty: Bool = true
    
    var remoteData: [ComicModel] = [] {
        didSet {
            let contentOffset = tableView.contentOffset
                tableView.reloadData()
                tableView.layoutIfNeeded()
                tableView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    var data: [ComicModel] {
        if !isSearchTextFieldEmpty {
            return searchData
        }
        return remoteData
    }
    
    var searchData: [ComicModel] = []
    
    var selectedComic: ComicModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadComicBunch()
        tableView.dataSource = self
        tableView.delegate = self
        searchSetup()
        // Do any additional setup after loading the view.
    }
    

    func searchSetup() {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self
        searchBar.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchBar
        navigationController?.navigationBar.sizeToFit()
    }
     //MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            if let destNav = segue.destination as? DetailVC {
                destNav.comicData = selectedComic
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func loadComicBunch(comicId: Int? = nil) {
            comicLoadedCount = 0
        
        getComicData(for: comicId)
    }
    
    func getComicData(for comicId: Int?) {
        
        Network.shared.getData(fileId: comicId) { [weak self] (object: ComicModel) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.comicLoadedCount = strongSelf.comicLoadedCount + 1
            strongSelf.remoteData.append(object)
            strongSelf.latestReceiveId = object.num
            if strongSelf.comicLoadedCount < strongSelf.comicBunchCount {
                if object.num > 1 {
                strongSelf.getComicData(for: object.num - 1)
                }
            }
            //return object
        } failure: { err in
            print(err.errorDescription)
        }
    }

}
