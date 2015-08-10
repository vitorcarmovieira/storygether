//
//  trechoTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 6/19/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class trechoTableViewCell: UITableViewCell {

    @IBOutlet weak var trechoLabel: UILabel!
    @IBOutlet weak var imagemEscritorTrecho: UIImageView!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var numFavoritadas: UILabel!
    var trecho: Trechos?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemEscritorTrecho.circularImageView()
        
        if let trecho = self.trecho{
            
            let user:Usuarios = trecho.escritor
            self.trechoLabel.text = trecho.trecho
            self.imagemEscritorTrecho.image = UIImage(data: user.foto)
            countFavoritadas(trecho.objectId)
        }
    }
    
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritadas.text{
            let num = (numString as NSString).integerValue
            self.numFavoritadas.text = (num + 1).description
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
    
    func countFavoritadas(objectId: String){
        
        let query = PFQuery(className: "favoritadas")
        query.whereKey("historiaId", equalTo: objectId)
        query.countObjectsInBackgroundWithBlock{
            (num, error) in
            if error == nil{
                self.numFavoritadas.text = num.description
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
