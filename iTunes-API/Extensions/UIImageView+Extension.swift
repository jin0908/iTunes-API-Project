//
//  UIImageView+Extension.swift
//  iTunes-API
//
//  Created by Hyeongjin Um on 10/15/18.
//  Copyright © 2018 Hyeongjin Um. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}

