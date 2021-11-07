//
//  BrowseTVHandler.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

extension BrowseVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let lastObjNum = data.last?.num , lastObjNum > 2 {
            return (data.count + 1)
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < data.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTVC", for: indexPath) as! BrowseTVC
            cell.fillData(data[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingTVC", for: indexPath) as! WaitingTVC
        cell.waitingIndicator.startAnimating()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count && (comicLoadedCount >= comicBunchCount) {
            loadComicBunch(comicId: latestReceiveId)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedComic = data[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
}
