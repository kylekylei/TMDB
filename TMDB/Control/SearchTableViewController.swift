//
//  SearchTableViewController.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/10.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    var searchMovieItems = [MovieItem]()
    var keyWord: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         Task {
            do {
                let movieResponse = try await MovieService.shared.fetchSearchMovie(with: "Jack Reacher")

                searchMovieItems = movieResponse.results
                tableView.reloadData()
                
            }catch {
                displayError(error, title: "Fail to fetch the Searching Movie data")

            }
        }

    }

    // MARK: - Table view data source

    @IBAction func searcgMovie(_ sender: Any) {
        guard let searchText = searchTextField.text else {return}
        keyWord = searchText
        print(keyWord!)
        Task {
            do {
                let movieResponse = try await MovieService.shared.fetchSearchMovie(with: keyWord ?? "Dark Knight")

                searchMovieItems = movieResponse.results
                tableView.reloadData()
                
            }catch {
                displayError(error, title: "Fail to fetch the Searching Movie data")
            }
        }
        
        
        
    }
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else {return}
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        searchMovieItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchTableViewCell.self)", for: indexPath) as! SearchTableViewCell
        let row = searchMovieItems[indexPath.row]
        
        cell.titleLabel.text = row.title
        cell.dateLabel.text = row.releaseDate

        Task {
            do {
                cell.movieImage.image = try await MovieService.shared.fetchImage(from: row.backdropImage, in: .w300)
            }catch {
                displayError(error, title: "Fail to fetch image")
            }
        }

        return cell
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailViewController? {
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil}
        
        return DetailViewController(coder: coder, movieItem: searchMovieItems[row])
    }
    


}
