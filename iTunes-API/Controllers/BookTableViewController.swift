//
//  BookTableViewController.swift
//  iTunes-API
//
//  Created by Hyeongjin Um on 10/14/18.
//  Copyright © 2018 Hyeongjin Um. All rights reserved.
//

import UIKit


class BookTableViewController: UITableViewController{
    private let cellId = "bookTableCellId"
    
    var books: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.title = "Popular Books"
        
        Networking.shared.fetch(route: .books) { (data) in
            if let iTunes = try? JSONDecoder().decode(ItuneResponse.self, from: data) {
                let books = iTunes.books
                self.books = books
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = books[indexPath.row].name
        return cell
    }
    
}
