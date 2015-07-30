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
            self.setNumTrechos()
            
            if let count = favoritadas?.count{
                self.numFavoritos.text = "\(count)"
                if var favoritadas = self.parseObject?["favoritadas"] as? [NSDictionary]{
                    if let user = PFUser.currentUser(){
                        let profile:NSDictionary = user.valueForKey("profile")! as! NSDictionary
                        if let index = find(favoritadas, profile){
                            self.buttonFavoritar.selected = true
                        }
                    }
                }
            }else {
                self.numFavoritos.text = "0"
                self.buttonFavoritar.selected = false
            }
        }
        
    }
    @IBAction func favoritar(sender: AnyObject) {
        
        if var favoritadas = self.parseObject?["favoritadas"] as? [NSDictionary]{
            if let user = PFUser.currentUser(){
                let profile:NSDictionary = user.valueForKey("profile")! as! NSDictionary
                if let index = find(favoritadas, profile){
                    println("Já foi favoritada")
                }else{
                    favoritadas.append(profile)
                    self.parseObject!["favoritadas"] = favoritadas
                    self.parseObject!.saveInBackground()
                    if var favoritas = user["favoritas"] as? [PFObject]{
                        favoritas.append(self.parseObject!)
                        user["favoritas"] = favoritas
                        user.saveInBackground()
                    }
                }
            }
        }else{
            if let user = PFUser.currentUser(){
                let profile:AnyObject = user.valueForKey("profile")!
                self.parseObject!["favoritadas"] = [profile]
                self.parseObject!.saveInBackground()
                
                user["favoritas"] = [self.parseObject!]
                user.saveInBackground()
                self.buttonFavoritar.selected = true
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setNumTrechos(){
        
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
