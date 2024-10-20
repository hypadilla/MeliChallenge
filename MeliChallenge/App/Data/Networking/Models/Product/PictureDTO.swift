//
//  PictureDTO.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 20/10/24.
//

/// Represents a data transfer object for a picture.
struct PictureDTO: Decodable {
    let secure_url: String
    
    func toDomain() -> Picture {
        return Picture(secure_url: self.secure_url)
    }
}
