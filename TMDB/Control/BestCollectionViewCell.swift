//
//  FeatureCollectionViewCell.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/8.
//

import UIKit

class BestCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView! {
        didSet {            
            movieImage.contentMode = .scaleAspectFill
            movieImage.layer.cornerRadius = 16
            movieImage.clipsToBounds = true
            movieImage.layer.opacity = 0.8

        }
    }
}
