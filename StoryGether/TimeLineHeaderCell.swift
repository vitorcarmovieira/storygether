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
        
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
    }
    
    @IBAction func changeToExplorar(sender: AnyObject) {
        
    }
    
    @IBAction func changeToAmigos(sender: AnyObject) {
        
    }
}
