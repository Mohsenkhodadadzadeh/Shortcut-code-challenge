//
//  SearchSRUHandler.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

extension BrowseVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
            isSearchTextFieldEmpty = text.count < 1
            if let intObj = Int(text) {
                searchData = remoteData.filter({ $0.safeTitle.lowercased().contains(text) || $0.num == intObj})
            } else {
                searchData = remoteData.filter({ $0.safeTitle.lowercased().contains(text)})
            }
            tableView.reloadData()
        }
    }
}
