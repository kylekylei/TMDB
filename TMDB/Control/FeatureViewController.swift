//
//  FeatureViewController.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/8.
//

import UIKit


@MainActor
class FeatureViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieTableView: UITableView!
    
    var bestMovieItems = [MovieItem]()
    var popularMovieItems = [MovieItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // BestMovie
        Task {
            do {
                let movieResponse = try await MovieService.shared.fetchBestMovie(in: 2021)
                bestMovieItems = movieResponse.results
                movieCollectionView.reloadData()
            } catch {
                displayError(error, title: "Fail to fetch the Best Movie data")
            }
        }
        configureCellSize()
        
        // PopularMovie
        Task {
            do {
                let movieResponse = try await MovieService.shared.fetchPopularMovie()
                popularMovieItems = movieResponse.results
                movieTableView.reloadData()
            } catch {
                displayError(error, title: "Fail to fetch the Popular Movie data")
            }
        }
    }
    
    @IBSegueAction func showDtail(_ coder: NSCoder) -> DetailViewController? {
        guard let  row  = movieTableView.indexPathForSelectedRow?.row else {return nil}
        return DetailViewController(coder: coder, movieItem: popularMovieItems[row])
    }
    
    @IBSegueAction func showDetailfromItem(_ coder: NSCoder) -> DetailViewController? {
        
        guard let item = movieCollectionView.indexPathsForSelectedItems?.first?.row else {return nil}
        return DetailViewController(coder: coder, movieItem: bestMovieItems[item])
    }
    

    
    

    
}

extension FeatureViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        popularMovieItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PopularTableViewCell.self)", for: indexPath) as! PopularTableViewCell
        
        let row = popularMovieItems[indexPath.row]

        
        cell.titleLabel.text = row.title
        cell.dateLabel.text = row.releaseDate
        cell.movieImage.image = UIImage(systemName: "photo")
        
        Task {
            do {
                cell.movieImage.image = try await MovieService.shared.fetchImage(from: row.backdropImage, in: .w300 )
            } catch {
                displayError(error, title: "Fail to fetch image")
            }
        }
        /*
         let imageUrl = MovieService.shared.fetchImage(urlStr: row.backdropImage)
         URLSession.shared.dataTask(with: imageUrl) { data, response, error in
             if let data = data {
                 DispatchQueue.main.async {
                     cell.movieImage.image = UIImage(data: data)
                 }
             }
         }.resume()
         */

        
        return cell
    }
    
    
}

extension FeatureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bestMovieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BestCollectionViewCell.self)", for: indexPath) as! BestCollectionViewCell
        
        let item = bestMovieItems[indexPath.item]
        
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.releaseDate
        cell.movieImage.image = UIImage(systemName: "photo")
        Task {
            do {
                cell.movieImage.image = try await MovieService.shared.fetchImage(from: item.backdropImage, in: .w500)
            } catch {
                displayError(error, title: "Fail to fetch image")
            }
        }

        
        return cell
    }
}

extension FeatureViewController {
    func configureCellSize() {
        let itemSpace: CGFloat = 0

        let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = movieCollectionView.bounds.width
        let height = width / 16 * 9
        flowLayout?.itemSize = CGSize(width: width, height: height)
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
