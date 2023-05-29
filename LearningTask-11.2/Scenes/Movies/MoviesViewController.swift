//
//  ViewController.swift
//  LearningTask-11.2
//
//  Created by rafael.rollo on 03/11/2022.
//

import UIKit

class MoviesViewController: UITableViewController {

    var moviesAPI: MoviesAPI?
    var moviesList: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }
    
    func loadMovies () {
        guard let api = moviesAPI else {return}
        
        api.getMovies(from: api.moviesUri) {  [weak self] data in
            guard let self = self else {return}
            
            self.moviesList.append(contentsOf:data.results)

        } failureHandler: { error in
            guard let errorDescription = error.errorDescription else {return}
            
            UIAlertController.showError(errorDescription, in: self)
        }
    }
}

//MARK: Prepares for segue
extension MoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "verDetalhesFilme" else {return}
        
        guard let destination = segue.destination as? MovieDetailsViewController,
              let cell = sender as? MovieTableViewCell else {
            fatalError("Unable to acquire necessary data to complete segue: \(segue.identifier!)")
        }
        
        destination.starshipsAPI = StarshipsAPI()
        destination.movie = cell.movie
    }
}

//MARK: TableView implementations
extension MoviesViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            fatalError("Unable to acquire cell to presente.")
        }
        
        let movie = moviesList[indexPath.row]
        cell.movie = movie
        
        return cell
    }
}
