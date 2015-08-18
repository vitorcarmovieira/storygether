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

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var quantTrechos: UILabel!
    @IBOutlet weak var quantFav: UILabel!
    
    var historia:Historia?
    
    override func awakeFromNib() {
        
        if let historia = historia{
            
            self.titulo.text = historia.parseToDictionary()["titulo"]
            self.createdAt.text = historia.parseToDictionary()["createdAt"]
            self.quantFav.text = historia.parseToDictionary()["quantFav"]
            self.quantTrechos.text = historia.parseToDictionary()["quantFav"]
            
        }
    }
}
