//
//  Movie.swift
//  iTunes-API
//
//  Created by Hyeongjin Um on 10/14/18.
//  Copyright © 2018 Hyeongjin Um. All rights reserved.
//

import Foundation

struct ItuneResponse: Decodable {

    // use nested enumerations to represent the hierarchy
    private enum RootKeys: String, CodingKey {
        case feed = "feed"
        
        enum FeedKeys: String, CodingKey {
            case results = "results"

            enum ResultsKeys: String, CodingKey {
                case artist = "artistName"
                case name = "name"
                case artwork = "artworkUrl100"
            }
        }
    }
    
    var movies: [Movie]
    var books: [Book]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: RootKeys.FeedKeys.self, forKey: .feed)
        
        // encountered nested array
        var resultUnkeyedContainer = try nestedContainer.nestedUnkeyedContainer(forKey: .results)
        var movies = [Movie]()
        var books = [Book]()
        while !resultUnkeyedContainer.isAtEnd {
            let movieContainer = try resultUnkeyedContainer.nestedContainer(keyedBy: RootKeys.FeedKeys.ResultsKeys.self)
            let artist = try movieContainer.decodeIfPresent(String.self, forKey: .artist) ?? "No artist"
            let name = try movieContainer.decodeIfPresent(String.self, forKey: .name) ?? "No Title"
            let artwork = try movieContainer.decodeIfPresent(String.self, forKey: .artwork) ?? "No image"
            let movie = Movie(name: name, artist: artist, artwork: artwork)
            let book = Book(name: name, artist: artist, artwork: artwork)
            movies.append(movie)
            books.append(book)
        }
        self.movies = movies
        self.books = books
    }
  
}

class Movie {
    let name : String
    let artist: String
    let artwork: String
    
    init(name: String, artist: String, artwork: String) {
        self.name = name
        self.artist = artist
        self.artwork = artwork
    }
}
