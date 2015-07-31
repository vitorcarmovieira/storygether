//
//  TimeLineHeaderCell.swift
//  StoryGether
//
//  Created by Vitor on 7/30/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class TimeLineHeaderCell: UITableViewCell {
    
    @IBOutlet weak var buttonExplorar: UIButton!
    @IBOutlet weak var buttonAmigos: UIButton!
    
    override func awakeFromNib() {
        
        let image = UIImage(named: "icon_sombra_friends_explorar")
        let size = self.bounds.size
        self.backgroundColor = UIColor(patternImage: image!)
    }
    
    @IBAction func changeToExplorar(sender: AnyObject) {
        
    }
    
    @IBAction func changeToAmigos(sender: AnyObject) {
        
    }
}
