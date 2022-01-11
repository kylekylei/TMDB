//
//  PopularTableViewCell.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/9.
//

import UIKit

class PopularTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView! {
        didSet {
            movieImage.contentMode = .scaleAspectFill
            movieImage.layer.cornerRadius = 8
            movieImage.clipsToBounds = true
            movieImage.layer.opacity = 1

        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
