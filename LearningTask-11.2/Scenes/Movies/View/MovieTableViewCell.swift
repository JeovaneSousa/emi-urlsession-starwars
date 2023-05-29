//
//  MovieTableViewCell.swift
//  LearningTask-11.2
//
//  Created by jeovane.barbosa on 12/12/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {return}
            
            titleLabel.text = movie.title
            episodeLabel.text = movie.episodeSubtitle
        }
    }
}
