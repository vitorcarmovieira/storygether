//
//  PerfilHistoriaCell.swift
//  StoryGether
//
//  Created by Vitor on 7/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class PerfilHistoriaCell: UITableViewCell {

    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelNumColaboradores: UILabel!
    @IBOutlet weak var labelNumFavoritos: UILabel!
    var historia:Historias?
    
    override func awakeFromNib() {
        
        if let historia = historia{
            
            self.labelTitulo.text = historia.titulo
            self.labelData.text = historia.createdAt.historyCreatedAt()
            self.labelNumColaboradores.text = historia.trechos?.count.description
            countFavoritadas()
            
        }
    }
    
    func countFavoritadas(){
        
        let parseHistoria:PFObject = PFObject(withoutDataWithClassName: "Historias", objectId: self.historia?.objectId)
        parseHistoria.fetchIfNeededInBackgroundWithBlock{
            (object, error) in
            if error == nil{
                if let historia = object{
                    if var favoritadas = historia["favoritadas"] as? [PFObject]{
                        self.labelNumFavoritos.text = favoritadas.count.description
                    }
                }
            }
        }
    }
}
