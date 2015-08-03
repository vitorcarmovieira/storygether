//
//  PerfilNumeroHistorias.swift
//  StoryGether
//
//  Created by Vitor on 7/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class PerfilNumeroHistorias: UITableViewCell {
    
    @IBOutlet weak var labelNumHistorias: UILabel!
    @IBOutlet weak var labelDescricao: UILabel!
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        if let user = Usuarios.getCurrent(){
            self.labelNumHistorias.text = user.historias.count.description
        }
    }
}
