//
//  HistoriaTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HistoriaTableViewCell: UITableViewCell {
    
    typealias dic = [String : String?]

    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var dataCriacao: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    @IBOutlet weak var numEscritores: UILabel!
    @IBOutlet weak var tituloHistoria: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var historiaLabel: UILabel!
    var historia: dic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.circularImageView()
        
        if let historia = self.historia{
            
            self.tituloHistoria.text = historia["titulo"]!
            self.historiaLabel.text = historia["trechoInicial"]!
            self.dataCriacao.text = historia["createdAt"]!
            if let url = historia["urlFoto"]{
                self.userImage.setImageAssync(url)
            }
            self.countFavoritadas(historia["objectId"]!!)
            
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritos.text{
            let num = (numString as NSString).integerValue
            self.numFavoritos.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        if let objectId = historia!["objectId"]{
            Model.favoritar(objectId!, block: {
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
        
        Model.countFavoritadas(objectId, completion: {
            num in
            self.numFavoritos.text = num
        })
    }
}
