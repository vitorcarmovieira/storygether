//
//  trechoTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 6/19/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class trechoTableViewCell: UITableViewCell {

    @IBOutlet weak var trechoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func curtir(sender: AnyObject) {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
