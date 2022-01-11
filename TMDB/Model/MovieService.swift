//
//  MovieService.swift
//  TMDB
//
//  Created by Kyle Lei on 2022/1/7.
//

import Foundation
import UIKit


class MovieService {
    enum MovieServiceError: Error, LocalizedError {
        case movieListNotFound
        case imageDataMissing
    }
    
    enum ImageSize: String {
        case original
        case w500
        case w300
        
    }
    static let shared = MovieService()
    private init() {}
    
    let apikey = "f69a666543d5253b51d768a993ef5f93"
    let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    
    func fetchBestMovie(in year: Int) async throws -> MovieResponse {
        var urlComponent = URLComponents(string: "\(baseURL)discover/movie")!
        urlComponent.queryItems = [
            URLQueryItem(name: "with_genres", value: "18"),
            URLQueryItem(name: "api_key", value: apikey),
            URLQueryItem(name: "primary_release_year", value: "\(year)")
        ]
        return try await movieResonse(urlComponent: urlComponent)
    }

    
    func fetchPopularMovie() async throws -> MovieResponse {
        var urlComponent = URLComponents(string: "\(baseURL)discover/movie")!
        urlComponent.queryItems = [
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "api_key", value: apikey),
        ]
        return try await movieResonse(urlComponent: urlComponent)
    }
      
    
    func fetchSearchMovie(with keyWord: String) async throws -> MovieResponse {
        var urlComponent = URLComponents(string: "\(baseURL)search/movie")!
        urlComponent.queryItems = [
              
            URLQueryItem(name: "api_key", value: apikey),
            URLQueryItem(name: "query", value: keyWord),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "include_adult", value: "false")
        ]

        return try await movieResonse(urlComponent: urlComponent)
    }
    
    func fetchhMovie(movieID: String) async throws -> MovieResponse {
        var urlComponent = URLComponents(string: "\(baseURL)movie/\(movieID)")!
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: apikey)
        ]

        return try await movieResonse(urlComponent: urlComponent)
    }
    
  
    
    func fetchMovieBackdrops(movieID: String) async throws -> BackdropResponse {
        var urlComponent = URLComponents(string: "\(baseURL)movie/\(movieID)/images")!
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: apikey)
        ]
        
        let url = urlComponent.url!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.movieListNotFound
        }
        
        print(httpResponse.statusCode)
        let decoder = JSONDecoder()
        let backgropResponse = try decoder.decode(BackdropResponse.self, from: data)
        return backgropResponse
    }
    
    func movieResonse(urlComponent: URLComponents) async throws -> MovieResponse {
        let url = urlComponent.url!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.movieListNotFound
        }
        
        print(httpResponse.statusCode)
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
        return movieResponse
    }
    
    
    
    func fetchImage(from urlStr: String, in size: ImageSize) async throws -> UIImage {
        let baseUrl = URL(string: "https://image.tmdb.org/t/p/\(size)")!
        let imageUrl = baseUrl.appendingPathComponent("\(urlStr)")
        
        let (data, reponse) = try await URLSession.shared.data(from: imageUrl)
        guard let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode == 200, let image = UIImage(data: data) else {
            throw MovieServiceError.imageDataMissing
        }
    
        return image
        
    }
    /*
    func fetchImage(urlStr: String) -> URL {
        let baseUrl = URL(string: "https://image.tmdb.org/t/p/w500")!
        let imageUrl = baseUrl.appendingPathComponent("\(urlStr)")
        return imageUrl
    }
    */
    func dataFormat(form date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }    
   
    
}
