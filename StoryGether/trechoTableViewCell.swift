//
//  trechoTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 6/19/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class trechoTableViewCell: UITableViewCell {

    @IBOutlet weak var trechoLabel: UILabel!
    @IBOutlet weak var imagemEscritorTrecho: UIImageView!
    var trecho: Trechos?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemEscritorTrecho.circularImageView()
        
        if let trecho = self.trecho{
            
            let user:Usuarios = trecho.escritor
            self.trechoLabel.text = trecho.trecho
            self.imagemEscritorTrecho.image = UIImage(data: user.foto)
        }
    }

    @IBAction func curtir(sender: AnyObject) {
        
//        if var curtidas = self.parseObject?["curtidas"] as? [PFObject]{
//            
//        }else{
//            if let user = PFUser.currentUser(){
//                let profile:AnyObject = user.valueForKey("profile")!
//                self.parseObject!["curtidas"] = [profile]
//                self.parseObject!.saveInBackground()
//            }
//        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
