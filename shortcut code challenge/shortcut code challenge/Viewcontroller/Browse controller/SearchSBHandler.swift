//
//  SearchSBHandler.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

extension BrowseVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancle clicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         print("search clicked")
    }
}
