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

    @IBOutlet weak var buttonFavoritar: UIButton!
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
            let favoritadas = historia["favoritadas"] as? [AnyObject]
            
            //async para pegar foto do usuario
            self.userImage.getImageAssync(user.valueForKey("urlFoto") as? String)
            self.tituloHistoria.text = (historia["titulo"] as! String)
            self.dataCriacao.text = historia.createdAt?.historyCreatedAt()
            self.historiaTextView.text = historia["trechoInicial"] as! String
            self.getNumTrechos()
            
            if let count = favoritadas?.count{
                self.numFavoritos.text = "\(count)"
                self.buttonFavoritar.selected = true
            }else {
                self.numFavoritos.text = "0"
                self.buttonFavoritar.selected = false
            }
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if var favoritadas = self.parseObject?["favoritadas"] as? [AnyObject]{
            if let user = PFUser.currentUser(){
                for favoritada in favoritadas{
                    if user.objectId == favoritada.valueForKey("id") as? String{
                        
                        let profile:AnyObject = user.valueForKey("profile")!
                        favoritadas.append(profile)
                        self.parseObject!["favoritadas"] = favoritadas
                        self.parseObject!.saveInBackground()
                    }
                }
            }
        }else{
            if let user = PFUser.currentUser(){
                let profile:AnyObject = user.valueForKey("profile")!
                self.parseObject!["favoritadas"] = [profile]
                self.parseObject!.saveInBackground()
                self.buttonFavoritar.selected = true
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func getNumTrechos(){
        
        var num:Int?
        var query: PFQuery = PFQuery(className: "Trechos")
        if let id = self.parseObject?.objectId{
            query.whereKey("historia", equalTo: id)
            query.countObjectsInBackgroundWithBlock{
                (count:Int32, error:NSError?) ->Void in
                
                if error == nil{
                    self.numEscritores.text = "\(count)"
                }
            }
        }
    }
}
