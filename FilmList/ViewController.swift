//
//  ViewController.swift
//  FilmList
//
//  Created by Rafael Oliveira on 05/04/17.
//  Copyright © 2017 Rafael Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var filmesSelecionados = [[String: String]]()
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "cell"
    let manager = DBManager.sharedDBManager
    var fav = false
    
    @IBOutlet weak var Populares: UIButton!
    @IBOutlet weak var Notas: UIButton!
    @IBOutlet weak var Favoritos: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Populares.setImage(UIImage(named:"pop.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        Notas.setImage(UIImage(named:"rating.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        Favoritos.setImage(UIImage(named:"liked.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        
        filmesSelecionados = getPopFilms()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fav {
            if manager.favoritos.count <= 1 {
                filmesSelecionados = getPopFilms()
                fav = false
            } else {
                filmesSelecionados = manager.favoritos
                filmesSelecionados.removeFirst()
            }
        }
        collectionView.reloadData()
    }
    
    //MARK: - Collectionview Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCell
        
        let aux = filmesSelecionados[indexPath.item]
        let fav = manager.isFavorite(String: aux["id"]!)
        
        //tratamento do valor da avaliação
        let nota = Float(aux["nota"]!)
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let sNota = formatter.string(from: NSNumber.init(value: nota!))!
        
        //configuração do card, cell, no grid
        cell.title.text = aux["titulo"]
        cell.rating.text = "Nota: " + sNota
        cell.image.image = getPoster(String: aux["img"]!)
        cell.like.image = fav ? UIImage.init(named: "hfill.png") : UIImage.init(named: "hempty.png")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filmesSelecionados.count
    }
    
    //MARK: - Collectionview Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detVC = storyBoard.instantiateViewController(withIdentifier: "detalhes") as! DetalhesVC
        
        detVC.movie = filmesSelecionados[indexPath.item]
        
        self.navigationController?.pushViewController(detVC, animated: true)

    }
    
    //MARK: - Ações
    @IBAction func showPopularFilms(_ sender: UIButton) {
        filmesSelecionados = getPopFilms()
        fav = false
        collectionView.reloadData()
    }
    
    @IBAction func showRatedFilms(_ sender: UIButton) {
        filmesSelecionados = getRanquedFilms()
        fav = false
        collectionView.reloadData()
    }

    @IBAction func showFavoriteFilms(_ sender: UIButton) {
        
        if manager.favoritos.count <= 1 {
            let alertController = UIAlertController(title: "Alerta", message: "Sua lista de filmes favoritos está vazia!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            filmesSelecionados = manager.favoritos
            filmesSelecionados.removeFirst()
            fav = true
            collectionView.reloadData()
        }
    }
}
