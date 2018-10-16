//
//  ViewController.swift
//  iTunes-API
//
//  Created by Hyeongjin Um on 10/14/18.
//  Copyright © 2018 Hyeongjin Um. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {
    
    private var cellId = "cellId"
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavbarAndView()
        Networking.shared.fetch(route: .movies) { (data) in
            // 2. convert data into decodable json data
            if let iTunes = try? JSONDecoder().decode(ItuneResponse.self, from: data) {
                self.movies = iTunes.movies
            }
        }
    }
    

    private func setupNavbarAndView() {
        self.navigationItem.title = "Top Movies"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Books", style: .plain, target: self, action: #selector(handleRightBarButton))
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleRightBarButton() {
        let bookVC = BookTableViewController()
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let movie = self.movies[indexPath.row]
        cell.imageView?.image = UIImage(named: "default_image")
        cell.textLabel?.text = movie.name
        if movie.artwork != "No image" {
            DispatchQueue.main.async {
                cell.imageView?.loadImageUsingCacheWithUrlString(urlString: movie.artwork)
            }
        }
        return cell
    }


}
