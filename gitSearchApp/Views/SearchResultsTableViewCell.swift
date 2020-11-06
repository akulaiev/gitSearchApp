//
//  SearchResultsTableViewCell.swift
//  gitSearchApp
//
//  Created by Anna Kulaieva on 05.11.2020.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
