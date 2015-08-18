//
//  HistoriaTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HistoriaTableViewCell: UITableViewCell {

    @IBOutlet weak var trechoInicial: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var urlFoto: UIImageView!
    @IBOutlet weak var quantFav: UILabel!
    @IBOutlet weak var quantTrechos: UILabel!
    var historia: Historia?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.urlFoto.circularImageView()
        
        if let historia =  self.historia{
            for (key, value) in historia.parseToDictionary(){
                self.setValue(value, forKeyPath: key + ".text")
            }
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.quantFav.text{
            let num = (numString as NSString).integerValue
            self.quantFav.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        historia?.favoritar()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
