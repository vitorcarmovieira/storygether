//
//  StartViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 15/08/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class StartViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var svTutorial: UIScrollView?
    @IBOutlet weak var pageControl: UIPageControl!
    var images: NSArray!
    var titles: NSArray!
    var subs: NSArray!
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewControllers = [storyboard.instantiateViewControllerWithIdentifier("intro") as! IntroViewController,storyboard.instantiateViewControllerWithIdentifier("intro") as! IntroViewController, storyboard.instantiateViewControllerWithIdentifier("intro") as! IntroViewController, storyboard.instantiateViewControllerWithIdentifier("login") as! LoginViewController];
        
        
        var bounds = UIScreen.mainScreen().bounds
        var width = bounds.size.width
        var height = bounds.size.height;
        
        svTutorial!.contentSize = CGSizeMake(4*width, height);
        svTutorial!.delegate = self
        
        
        
        var idx:Int = 0;
        for viewController in viewControllers {
            if(idx<3){
                (viewController as!IntroViewController).imageName = self.images[idx] as! UIImage
                (viewController as!IntroViewController).titleText = self.titles[idx] as! String
                (viewController as!IntroViewController).subText = self.subs[idx] as! String
            }
            addChildViewController(viewController);
            let originX:CGFloat = CGFloat(idx) * width;
            viewController.view.frame = CGRectMake(originX, 0, width, height);
            svTutorial!.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            
            idx++;
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth: CGFloat = self.svTutorial!.frame.size.width;
        
        var page: Int  = Int(floor((self.svTutorial!.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1;
        self.pageControl.currentPage = page;
    }
}
