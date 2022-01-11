//
//  DetailViewController.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/9.
//

import UIKit

@MainActor
class DetailViewController: UIViewController {
    
    let movieItem: MovieItem
    init?(coder: NSCoder, movieItem: MovieItem) {
        self.movieItem = movieItem
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backdropItems = [BackdropItem]()

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = 32
            posterImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            posterImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var backDropCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Detail
        Task {
            do {
                updateUI()
                self.posterImage.image = try await MovieService.shared.fetchImage(from: movieItem.posterImage, in: .original)
            } catch {
                displayError(error, title: "Failed to fetch items")
            }
        }
        
        // Backdrop
        Task {
            do {
                let backgropResponse = try await MovieService.shared.fetchMovieBackdrops(movieID: "\(movieItem.id)")
                backdropItems = backgropResponse.backdrops
                backDropCollectionView.reloadData()
            }catch {
                displayError(error, title: "Failed to fetch backgrop")
            }
        }
   
    }
    
    func updateUI() {
        titleLabel.text = movieItem.title
        dateLabel.text = movieItem.releaseDate
        descriptionLabel.text = movieItem.description
 
    }

}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        backdropItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BackDropCollectionViewCell.self)", for: indexPath) as! BackDropCollectionViewCell
        
        let item = backdropItems[indexPath.item]
        Task {
            do {
                cell.backgropImage.image = try await MovieService.shared.fetchImage(from: item.path, in: .w300)
            }catch {
                displayError(error, title: "Fail to fetch image")
            }
            
        }
        
        
        return cell
    }
    
    
}

extension DetailViewController {
    func configureCellSize() {
        let itemSpace: CGFloat = 2

        let flowLayout = backDropCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let height = backDropCollectionView.bounds.height
        flowLayout?.itemSize = CGSize(width: height, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.minimumInteritemSpacing = itemSpace
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else {return}
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
