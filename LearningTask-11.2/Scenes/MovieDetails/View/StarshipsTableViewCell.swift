//
//  StarshipsTableViewCell.swift
//  LearningTask-11.2
//
//  Created by jeovane.barbosa on 12/12/22.
//

import UIKit

class StarshipsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var starship: Starship? {
        didSet {
            guard let starship = starship else {return}
            
            titleLabel.text = starship.name
            subtitleLabel.text = starship.model
        }
    }
}
