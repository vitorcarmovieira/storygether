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
        if let user = parseObjects{
            self.imagemUser.text = user["urlFoto"] as! String
            self.nomeUser.text = user["name"] as? String
        }
    }
    
    @IBAction func seguir(sender: AnyObject) {
        
        self.buttonSeguindo.selected = true
        if let object = parseObjects as? PFUser{
            Model.seguir(object)
        }
    }
}
