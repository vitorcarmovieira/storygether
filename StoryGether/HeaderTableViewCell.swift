//
//  HeaderTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class HeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trechoLabel: UILabel!
    @IBOutlet weak var tituloHistoriaText: UILabel!
    @IBOutlet weak var nomeCriadorLabel: UILabel!
    @IBOutlet weak var imagemCriador: UIImageView!
    @IBOutlet weak var numAmigos: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var numFavoritadasTrecho: UILabel!
    var trecho:Trechos?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemCriador.circularImageView()
    
        if let trecho = trecho{
            
            self.trechoLabel.text = trecho.trecho
            let user:Usuarios = trecho.escritor
            self.imagemCriador.image = UIImage(data: user.foto)
            self.nomeCriadorLabel.text = user.nome
            countFavoritadasTrecho(trecho.objectId)
        }
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritadasTrecho.text{
            let num = (numString as NSString).integerValue
            self.numFavoritadasTrecho.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        if let objectId = self.trecho?.objectId{
            Model.favoritar(objectId, block: {
                bool in
                if bool{
                    
                }
            })
        }
    }

    @IBAction func finalizar(sender: AnyObject) {
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func countFavoritadasTrecho(objectId: String){
        
        let query = PFQuery(className: "favoritadas")
        query.whereKey("historiaId", equalTo: objectId)
        query.countObjectsInBackgroundWithBlock{
            (num, error) in
            if error == nil{
                self.numFavoritadasTrecho.text = num.description
            }
        }
    }
    
    func countFavoritadasHistoria(objectId: String){
        
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
