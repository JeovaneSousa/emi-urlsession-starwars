//
//  Movies.swift
//  LearningTask-11.2
//
//  Created by jeovane.barbosa on 12/12/22.
//

import Foundation


struct Films: Decodable {
    let count: Int?
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String?
    let episodeId: Int?
    let starships: [String?]
    let producer: String?
    let director: String?
    let releaseDate: Date
    var episodeSubtitle: String {
        return "Episode \(episodeId!)"
    }
    
    enum CodingKeys: String, CodingKey {
        case title, starships, producer, director
        case episodeId = "episode_id"
        case releaseDate = "release_date"
    }
}
