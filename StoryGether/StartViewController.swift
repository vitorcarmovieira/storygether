//
//  StartViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 15/08/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class StartViewController: UIViewController,UIScrollViewDelegate {
    var images: NSArray!
    var titles: NSArray!
    var subs: NSArray!
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = NSArray(array: [UIImage(named: "storygether_telainicial1")!,UIImage(named: "storygether_telainicial2")!,UIImage(named: "storygether_telainicial3")!]);
        
        self.titles = NSArray(array:
            [
                NSLocalizedString("Make stories", comment:"Init of phrase(Make stories with your friends) (Do stories) "),
                NSLocalizedString("Begin a story", comment:"Init of phrase(Begin a story or continue one) (Start to write a story) "),
                NSLocalizedString("Have fun", comment:"Init of phrase(Have fun and be creative) (Have fun) ")])
        self.subs = NSArray(array:
            [
                NSLocalizedString("with your friends", comment:"finish of phrase(Make stories with your friends) (with a help from your friends) "),
                NSLocalizedString("or continue one", comment:"finish of phrase(Begin a story or continue one) (continue a story) "),
                NSLocalizedString("and be creative", comment:"finish of phrase(Have fun and be creative) (be creative with stories) ")])
    
    
    }
}
