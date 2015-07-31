//
//  UserCell.swift
//  StoryGether
//
//  Created by Vitor on 7/31/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imagemUser: UIImageView!
    @IBOutlet weak var nomeUser: UILabel!
    @IBOutlet weak var buttonSeguindo: UIButton!
    
    override func awakeFromNib() {
        
        self.imagemUser.circularImageView()
    }
    
    @IBAction func seguir(sender: AnyObject) {
        
        self.buttonSeguindo.selected = true
    }
}
