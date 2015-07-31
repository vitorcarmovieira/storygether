//
//  UserCell.swift
//  StoryGether
//
//  Created by Vitor on 7/31/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class UserCell: UITableViewCell {

    @IBOutlet weak var imagemUser: UIImageView!
    @IBOutlet weak var nomeUser: UILabel!
    @IBOutlet weak var buttonSeguindo: UIButton!
    var parseObjects:PFObject?
    
    override func awakeFromNib() {
        
        self.imagemUser.circularImageView()
    }
    
    @IBAction func seguir(sender: AnyObject) {
        
        self.buttonSeguindo.selected = true
        if let user = PFUser.currentUser(){
            if var seguindo = user["seguindo"] as? [PFObject]{
                seguindo.append(self.parseObjects!)
                user["seguindo"] = seguindo
                user.saveInBackground()
                
                if var seguidores = self.parseObjects?["seguidores"] as? [PFObject]{
                    seguidores.append(user)
                    self.parseObjects?["seguidores"] = seguidores
                    self.parseObjects?.saveInBackground()
                }
            }else{
                user["seguindo"] = [self.parseObjects!]
                user.saveInBackground()
                
                self.parseObjects?["seguidores"] = [user]
                self.parseObjects?.saveInBackground()
            }
        }
    }
}
