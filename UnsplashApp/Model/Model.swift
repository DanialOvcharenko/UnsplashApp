//
//  Model.swift
//  UnsplashApp
//
//  Created by Mac on 21.01.2023.
//

import Foundation

struct Photo: Identifiable, Decodable, Hashable {
    
    var id: String
    var urls: [String : String]
    
}

struct SearchPhoto: Decodable {
    
    var results: [Photo]
    
}
