//
//  WebService.swift
//  FilmList
//
//  Created by Rafael Oliveira on 05/04/17.
//  Copyright © 2017 Rafael Oliveira. All rights reserved.
//

import Foundation
import UIKit


struct urlConstants {
    static let pop = "https://api.themoviedb.org/3/movie/popular"
    static let ranqued = "https://api.themoviedb.org/3/movie/top_rated"
    static let key = "?api_key=b5127d1016c968d30de8d0d6cc725a73"
    static let imgPath = "https://image.tmdb.org/t/p/w370_and_h556_bestv2"
}

var filmes = [[String: String]]()

func parse(json: JSON) {
    
    filmes.removeAll()
    
    for result in json["results"].arrayValue {
        let id = result["id"].stringValue
        let titulo = result["title"].stringValue
        let data = result["release_date"].stringValue
        let sinopse = result["overview"].stringValue
        let imgRef = result["backdrop_path"].stringValue
        let nota = result["vote_average"].stringValue
        
        let obj = ["id": id, "titulo": titulo, "data": data, "sinopse": sinopse, "img": imgRef, "nota": nota]
        
        filmes.append(obj)
    }
}

func getPopFilms() -> [[String: String]] {
    let urlString = urlConstants.pop + urlConstants.key
    
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data: data)
            
            if json["_error"] == nil {
                parse(json: json)
            }
        }
    }
    
    return filmes
}

func getRanquedFilms() -> [[String: String]] {
    let urlString = urlConstants.ranqued + urlConstants.key
    
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data: data)
            
            if json["_error"] == nil {
                parse(json: json)
            }
        }
    }
    
    return filmes
}

func getPoster(String: String) -> UIImage {
    let imgUrl = urlConstants.imgPath + String
    var aux = UIImage()
    
    if let url = URL(string: imgUrl) {
        if let data = try? Data(contentsOf: url) {
            aux = UIImage.init(data: data)!
        }
    } else {
        aux = UIImage.init(named: "notfound.jpg")!
    }
    
    let img = aux
    
    return img
}


