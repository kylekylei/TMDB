//
//  MovieItem.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/7.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieItem]
}

struct MovieItem: Codable {
    
    let id: Int
    let title: String
    let description: String
    let backdropImage: String
    let posterImage: String
    let releaseDate: String
    
    
    enum CodingKeys: String, CodingKey {
        case backdropImage = "backdrop_path"
        case id
        case title
        case description = "overview"
        case posterImage = "poster_path"
        case releaseDate = "release_date"
    }
}
 

struct MovieImages: Codable {
    let backdrops: [Image]
    let posters: [Image]

    
    struct Image: Codable {
        let language: String?
        let path: String
        
        enum CodingKeys: String, CodingKey {
            case language = "iso_639_1"
            case path = "file_path"
        }
        
    }
}


struct BackdropResponse: Codable {
    let backdrops: [BackdropItem]
}

struct BackdropItem: Codable {
    let path: String
    
    enum CodingKeys: String, CodingKey {
        case path = "file_path"
    }
    
}
