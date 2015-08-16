//
//  HistoriaTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HistoriaTableViewCell: UITableViewCell, ModelDelegate {
    
    typealias dic = [String : String]

    @IBOutlet weak var trechoInicial: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var numEscritores: UILabel!
    @IBOutlet weak var favoritadas: UILabel!
    @IBOutlet weak var urlFoto: UIImageView!
    var historia: dic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Model.sharedStore.delegate = self
        
        self.urlFoto.circularImageView()
        
        if let historia = self.historia{
            
            for (key, value) in historia{
                self.setValue(value, forKeyPath: key + ".text")
            }
            
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.favoritadas.text{
            let num = (numString as NSString).integerValue
            self.favoritadas.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        if let objectId = historia!["objectId"]{
            Model.favoritar(objectId, block: {
                bool in
                if bool{
                    
                }
            })
        }
    }
    
    func didChangeNumFavoritadas(num: String) {
        
        self.favoritadas.text = num
    }
    
    func didChangeNumTrechos(num: String) {
        
        self.numEscritores.text = num
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
