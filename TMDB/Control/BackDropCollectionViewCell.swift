//
//  BackDropCollectionViewCell.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/11.
//

import UIKit

class BackDropCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgropImage: UIImageView! {
        didSet {
            backgropImage.contentMode = .scaleAspectFill
            backgropImage.layer.cornerRadius = 16
            backgropImage.clipsToBounds = true
        }
    }
    
}
