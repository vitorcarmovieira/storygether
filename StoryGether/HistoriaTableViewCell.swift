//
//  HistoriaTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class HistoriaTableViewCell: UITableViewCell {

    @IBOutlet weak var dataCriacao: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    @IBOutlet weak var numEscritores: UILabel!
    @IBOutlet weak var tituloHistoria: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var historiaTextView: UITextView!
    var parseObject:PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.circularImageView()
        
        if let historia = self.parseObject{
            
            let user:AnyObject = historia["criador"]!
            
            //async para pegar foto do usuario
            self.userImage.getImageAssync(user.valueForKey("urlFoto") as? String)
            self.tituloHistoria.text = (historia["titulo"] as! String)
            self.dataCriacao.text = historia.createdAt?.historyCreatedAt()
            self.historiaTextView.text = historia["trechoInicial"] as! String
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
