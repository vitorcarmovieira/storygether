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
        Model.sharedStore.update()
        
    }
    
    @IBAction func changeToAmigos(sender: AnyObject) {
        Model.sharedStore.getAllHistoriasAmigos()
        
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
