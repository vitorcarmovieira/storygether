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
            countFavoritadas(historia.objectId)
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritos.text{
            let num = (numString as NSString).integerValue
            self.numFavoritos.text = (num + 1).description
        }
        
        self.historia?.favoritada = Usuarios.getCurrent()!
        Historias.saveOrUpdate()
        
        if let objectId = self.historia?.objectId{
            Model.favoritar(objectId, block: {
                bool in
                if bool{
                    
                }
            })
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func countFavoritadas(objectId: String){
        
        let query = PFQuery(className: "favoritadas")
        query.whereKey("historiaId", equalTo: objectId)
        query.countObjectsInBackgroundWithBlock{
            (num, error) in
            if error == nil{
                self.numFavoritos.text = num.description
            }
        }
    }
}
