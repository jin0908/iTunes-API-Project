//
//  Networking.swift
//  iTunes-API
//
//  Created by Hyeongjin Um on 10/14/18.
//  Copyright © 2018 Hyeongjin Um. All rights reserved.
//

import Foundation

enum Route {
    case movies
    case books
    
    func path() -> String {
        switch self {
        case .movies:
            return "us/movies/top-movies/all/10/explicit.json"
        case .books:
            return "us/books/top-free/all/10/explicit.json"
        }
    }
  
}

class Networking {
    //Singleton
    static let shared = Networking()
    
    let baseUrl = "https://rss.itunes.apple.com/api/v1/"
    let session = URLSession.shared
    
    // model: Decodable -> if you want parse data into a decodable object
    func fetch(route: Route, completion: @escaping (Data) -> Void) {
        
        // 1. convert string to url to fetch date
        let urlString = URL(string: baseUrl.appending(route.path()))
        
        session.dataTask(with: urlString!) { (data, response, error) in
            if let data = data {
                completion(data)
            } else {
                print(error?.localizedDescription ?? "Error")
            }
            }.resume()
        
    }
    
}
