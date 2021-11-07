//
//  BrowseTVC.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

class BrowseTVC: UITableViewCell {

    @IBOutlet weak var comicNumberLabel: UILabel!
    @IBOutlet weak var comicNameLabel: UILabel!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillData(_ data: ComicModel) {
        comicNumberLabel.text = "\(data.num)"
        comicNameLabel.text = data.safeTitle
        publishedDateLabel.text = data.longDate ?? ""
    }
    
}
