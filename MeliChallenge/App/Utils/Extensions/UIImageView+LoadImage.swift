//
//  UIImageView+LoadImage.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        DispatchQueue.main.async {
            self.image = placeholder
        }
        
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            return
        }
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error al descargar la imagen: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No se pudo convertir los datos a UIImage para la URL: \(url.absoluteString)")
                return
            }
            
            UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
