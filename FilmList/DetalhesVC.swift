//
//  DetalhesVC.swift
//  FilmList
//
//  Created by Rafael Oliveira on 09/04/17.
//  Copyright © 2017 Rafael Oliveira. All rights reserved.
//

import UIKit

class DetalhesVC: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var like: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var sinopse: UILabel!
    
    var movie = [String: String]()
    let manager = DBManager.sharedDBManager
    var fav = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapFavorite(sender:)))
        like.addGestureRecognizer(tapGesture)
        
        //tratamento do valor da avaliação
        let nota = Float(movie["nota"]!)
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let sNota = formatter.string(from: NSNumber.init(value: nota!))!
        
        //verifica se o filme está nos favoritos
        fav = manager.isFavorite(String: movie["id"]!)
        
        //tratamento da data de lançamento
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: movie["data"]!)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let st = dateFormatter.string(from: date!)
        
        
        //configuração inicial da tela
        poster.image = getPoster(String: movie["img"]!)
        like.image = fav ? UIImage.init(named: "hfill.png") : UIImage.init(named: "hempty.png")
        movieName.text = movie["titulo"]
        releaseDate.text = "Lançamento: " + st
        rating.text = "Nota: " + sNota
        sinopse.text = movie["sinopse"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapFavorite(sender: AnyObject) {
        if fav {
            if manager.removeFavorite(Movie: movie) {
                fav = false
            }
        } else {
            if manager.addFavorite(Movie: movie) {
                fav = true
            }
        }
        like.image = fav ? UIImage.init(named: "hfill.png") : UIImage.init(named: "hempty.png")
    }
}
