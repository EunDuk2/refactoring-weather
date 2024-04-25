//
//  ImageManager.swift
//  WeatherForecast
//
//  Created by EUNSUNG on 4/25/24.
//

import UIKit

struct ImageManager {
    private let imageChache: NSCache<NSString, UIImage> = NSCache()
    
    func downloadImage(urlString: String) async -> UIImage? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image: UIImage = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func getImageChache(forKey: String) -> UIImage? {
        guard let image = imageChache.object(forKey: forKey as NSString) else { return nil }
        return image
    }
    
    func setImageChache(image: UIImage, forKey: String) {
        imageChache.setObject(image, forKey: forKey as NSString)
    }
}
