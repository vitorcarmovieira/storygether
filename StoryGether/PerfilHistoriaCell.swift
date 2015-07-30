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
    var parseObject:PFObject?
    
    override func awakeFromNib() {
        
        if let historia = parseObject{
            
            self.labelTitulo.text = historia["titulo"] as? String
            let str = historia["titulo"] as? String
            self.labelData.text = historia.createdAt?.historyCreatedAt()
        }
    }
}
