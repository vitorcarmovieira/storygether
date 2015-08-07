//
//  HistoriaTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class HistoriaTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var dataCriacao: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    @IBOutlet weak var numEscritores: UILabel!
    @IBOutlet weak var tituloHistoria: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var historiaLabel: UILabel!
    var historia: Historias?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.circularImageView()
        
        if let historia = self.historia{
            
            let user:Usuarios = historia.criador
            
            let image = UIImage(data: user.foto)
            self.userImage?.image = image
            self.tituloHistoria.text = historia.titulo
            self.dataCriacao.text = historia.createdAt.historyCreatedAt()
            self.historiaLabel.text = historia.trechoInicial
            self.numEscritores.text = historia.trechos?.count.description
            
            if let favoritada = historia.favoritada{
                self.buttonFavoritar.selected = true
            }
            
            countFavoritadas()
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        self.historia?.favoritada = Usuarios.getCurrent()!
        Historias.saveOrUpdate()
        
        let parseHistoria:PFObject = PFObject(withoutDataWithClassName: "Historias", objectId: self.historia?.objectId)
        parseHistoria.fetchIfNeededInBackgroundWithBlock{
            (object, error) in
            if error == nil{
                if var historia = object{
                    if var favoritadas = historia["favoritadas"] as? [PFUser]{
                        println("\(favoritadas)")
                        for favoritada in favoritadas{
                            if let user = PFUser.currentUser(){
                                let objectId = favoritada.objectId!
                                if objectId == user.objectId!{
                                    println("Já foi favoritada")
                                }else{
                                    favoritadas.append(user)
                                    historia["favoritadas"] = favoritadas
                                    historia.saveInBackground()
                                    if var favoritas = user["favoritas"] as? [PFObject]{
                                        favoritas.append(historia)
                                        user["favoritas"] = favoritas
                                        user.saveInBackground()
                                    }
                                }
                            }
                        }
                    }else{
                        if let user = PFUser.currentUser(){
                            historia["favoritadas"] = [user]
                            historia.saveInBackground()
                            
                            user["favoritas"] = [historia]
                            user.saveInBackground()
                            self.buttonFavoritar.selected = true
                        }
                    }
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func countFavoritadas(){
        
        let parseHistoria:PFObject = PFObject(withoutDataWithClassName: "Historias", objectId: self.historia?.objectId)
        parseHistoria.fetchIfNeededInBackgroundWithBlock{
            (object, error) in
            if error == nil{
                if let historia = object{
                    if var favoritadas = historia["favoritadas"] as? [PFObject]{
                        self.numFavoritos.text = favoritadas.count.description
                    }
                }
            }
        }
    }
}
