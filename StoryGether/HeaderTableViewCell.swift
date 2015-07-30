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
    var parseObject:PFObject?
    var tituloHistoria:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemCriador.circularImageView()
        
        if let trecho = parseObject{
            
            self.trechoLabel.text = trecho["trecho"] as? String
            self.tituloHistoriaText.text = self.tituloHistoria
            let user:AnyObject? = trecho["escritor"]
            self.imagemCriador.getImageAssync(user?.valueForKey("urlFoto") as? String)
            self.nomeCriadorLabel.text = user?.valueForKey("name") as? String
        }
    }

    @IBAction func finalizar(sender: AnyObject) {
    }
    
    @IBAction func curtir(sender: AnyObject) {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
