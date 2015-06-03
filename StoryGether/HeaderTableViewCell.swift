//
//  HeaderTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 5/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var trechoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func save(sender: AnyObject) {
        
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
