//
//  DBManager.swift
//  FilmList
//
//  Created by Rafael Oliveira on 09/04/17.
//  Copyright © 2017 Rafael Oliveira. All rights reserved.
//

import Foundation

final class DBManager {
    
    var favoritos : [[String: String]] = [[:]]
    var dataFilePath: String?
    
    //Verifica se o arquivo dos favoritos já existe, caso contrário cria o arquivo
    private init() {
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        dataFilePath = docsDir.appending("data.archive")
        
        if filemgr.fileExists(atPath: dataFilePath!) {
            let dataArray = NSKeyedUnarchiver.unarchiveObject(withFile: dataFilePath!) as! [[String: String]]
            favoritos = dataArray
        } else {
            NSKeyedArchiver.archiveRootObject(favoritos, toFile: dataFilePath!)
        }
    }
    
    //MARK: Shared Instance
    static let sharedDBManager: DBManager = DBManager()
    
    //Verifica se um filme já está salvo como favorito
    func isFavorite(String: String) -> Bool {
        if favoritos.count > 1 {
            for movie in favoritos {
                if movie["id"] == String {
                    return true
                }
            }
        }
        return false
    }
    
    func addFavorite(Movie: [String: String]) -> Bool {
        favoritos.append(Movie)
        
//        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        dataFilePath = docsDir.appending("data.archive")
        
        if try! NSKeyedArchiver.archiveRootObject(favoritos, toFile: dataFilePath!) {
            return true
        }
        
        favoritos.removeLast()
        return false
    }
    
    func removeFavorite(Movie: [String: String]) -> Bool {
        let bkpFav = favoritos
        var n = 0
        
        for movieAux in favoritos {
            if movieAux["id"] == Movie["id"] {
                break
            } else {
                n += 1
            }
        }
        
        favoritos.remove(at: n)
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        dataFilePath = docsDir.appending("data.archive")
        
        if try! NSKeyedArchiver.archiveRootObject(favoritos, toFile: dataFilePath!) {
            return true
        }
        
        favoritos = bkpFav
        return false
        
    }
}
