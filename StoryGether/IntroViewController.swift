//
//  IntroViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 14/08/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    var pageIndex: Int?
    var titleText: String!
    var subText: String!
    var imageName: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImage.image = imageName
        self.lbTitle.text = self.titleText
        self.lbSub.text = self.subText
        
    }
}
