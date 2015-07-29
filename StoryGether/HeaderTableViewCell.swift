//
//  HeaderTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trechoTextView: UITextView!
    @IBOutlet weak var tituloHistoriaText: UILabel!
    @IBOutlet weak var nomeCriadorLabel: UILabel!
    @IBOutlet weak var imagemCriador: UIImageView!
    @IBOutlet weak var numAmigos: UILabel!
    @IBOutlet weak var numFavoritos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemCriador.circularImageView()
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
