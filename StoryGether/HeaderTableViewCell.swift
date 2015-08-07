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
    var trecho:Trechos?
    var tituloHistoria:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemCriador.circularImageView()
    
        if let trecho = trecho{
            
            self.trechoLabel.text = trecho.trecho
            self.tituloHistoriaText.text = self.tituloHistoria
            let user:Usuarios = trecho.escritor
            self.imagemCriador.image = UIImage(data: user.foto)
            self.nomeCriadorLabel.text = user.nome
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
    
    func setNumTrechos(){
        
//        var num:Int?
//        var query: PFQuery = PFQuery(className: "Trechos")
//        if let id = self.parseObject?.objectId{
//            query.whereKey("historia", equalTo: id)
//            query.countObjectsInBackgroundWithBlock{
//                (count:Int32, error:NSError?) ->Void in
//                
//                if error == nil{
//                    self.numAmigos.text = "\(count)"
//                }
//            }
//        }
    }

}
