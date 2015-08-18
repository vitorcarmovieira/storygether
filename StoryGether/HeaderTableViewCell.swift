//
//  HeaderTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var urlFoto: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var trecho: UILabel!
    @IBOutlet weak var numAmigos: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var numFavoritadasTrecho: UILabel!
    var _trecho: Trecho?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.urlFoto.circularImageView()
        
        if let _trecho = _trecho{
            for (key, value) in _trecho.parseToDictionary(){
                self.setValue(value, forKeyPath: key + ".text")
            }
        }
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritadasTrecho.text{
            let num = (numString as NSString).integerValue
            self.numFavoritadasTrecho.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        _trecho?.favoritar()
    }

    @IBAction func finalizar(sender: AnyObject) {
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
