//
//  FavoriteTVHandler.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit
import CoreData

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseTVC", for: indexPath) as! BrowseTVC
        cell.fillData(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let itemId = data[indexPath.row].num
            let fetch = NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
            fetch.predicate = NSPredicate(format:"num == \(itemId)")
            if let object = (try? managedContext.fetch(fetch))?.first {
                managedContext.delete(object)
            }
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedComic = data[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
}
