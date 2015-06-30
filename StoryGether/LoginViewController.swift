//
//  LoginViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 28/06/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var svTutorial: UIScrollView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btLogin: UIButton!
    var images: NSArray!
    var titles: NSArray!
    var subs: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = NSArray(array: [UIImage(named: "storygether_telainicial1")!,UIImage(named: "storygether_telainicial2")!,UIImage(named: "storygether_telainicial3")!]);
        self.titles = NSArray(array: ["Make stories","Begin a story","Have fun"])
        self.subs = NSArray(array: ["with your friends","or continue one","and be creative"])
        
        self.svTutorial.delegate=self
        
        for (var i: Int = 0; i < self.images.count; i++) {
            
            var image: UIImage  = self.images[i] as! UIImage;
            var imageview: UIImageView  = UIImageView(image: image)
            
            var frame:CGRect = CGRect()
            
            frame.origin.x = self.svTutorial.frame.size.width * CGFloat(i)
            
            frame.origin.y = 0
            
            frame.size = self.svTutorial.frame.size
            
            imageview.frame = frame
            
            self.svTutorial.addSubview(imageview)
            
            
            
        }
        
        
        
        self.svTutorial.contentSize =
            CGSizeMake(self.svTutorial.frame.size.width * CGFloat(self.images.count), self.svTutorial.frame.size.height)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth: CGFloat = self.svTutorial.frame.size.width;
        
        var page: Int  = Int(floor((self.svTutorial.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1;
        self.lbTitle.text = self.titles[page] as? String
        self.lbSub.text = self.subs[page] as? String
        self.pageControl.currentPage = page;
    }
}
