//
//  MovieDetailsViewController.swift
//  LearningTask-11.2
//
//  Created by jeovane.barbosa on 12/12/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var starshipsAPI: StarshipsAPI?
    var urls: [URL]?
    
    var movie: Movie? {
        didSet {
            urls = setupUrls()
        }
    }
    
    var listaDeStarships: [Starship] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView(for: movie)
        loadStarships()
    }
    
    private func setupHeaderView(for movie: Movie?) {
        guard let movie = movie else {return}
        
        titleLabel.text = movie.title
        subtitleLabel.text = movie.episodeSubtitle
        producerNameLabel.text = movie.producer
        directorNameLabel.text = movie.director
        releaseDateLabel.text = DateFormatter.format(date: movie.releaseDate, to: DateFormatter.CustomPattern.yearMonthAndDay)
    }
    
    private func setupUrls() -> [URL]? {
        let urls = movie?.starships.map({ starshipURI -> URL in
            URL(string: starshipURI!)!
        })
        
        return urls
    }
    
    private func loadStarships () {
        guard let urls = urls else {return}
        
        starshipsAPI?.getAll(batching: urls, completionHandler: { [weak self] (items, error) in
            guard let self = self else {return}
            
            if let error = error {
                UIAlertController.showError(error.localizedDescription, in: self)
            }
            
            self.listaDeStarships = items
        })
        
    }
}
    
// MARK: TableView Implementations

extension MovieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDeStarships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipTableViewCell", for: indexPath) as? StarshipsTableViewCell else {
            fatalError("Unable to acquire cell to present.")
        }
        
        let starship = listaDeStarships[indexPath.row]
        cell.starship = starship
        
        return cell
    }

}

extension MovieDetailsViewController: UITableViewDelegate {}
