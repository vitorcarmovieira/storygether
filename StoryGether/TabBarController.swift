//
//  TabBarController.swift
//  StoryGether
//
//  Created by Vitor on 6/4/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//        
//        CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
//        if (heightDifference < 0) {
//            button.center = self.tabBar.center;
//        } else {
//            CGPoint center = self.tabBar.center;
//            center.y = center.y - heightDifference/2.0;
//            button.center = center;
//        }
//        
//        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.view addSubview:button];
//        self.centerButton = button;
        
        let buttonImage: UIImage? = UIImage(named: "tabbar_icon_criar")
        
        var button: UIButton = UIButton(frame: CGRectMake(0.0, 0.0, buttonImage!.size.width - 75, buttonImage!.size.height - 75))
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        
        let heightDifference: CGFloat = buttonImage!.size.height - self.tabBar.frame.size.height
        if heightDifference < 0 {
            
            button.center = self.tabBar.center
        } else{
            
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/3.5
            button.center = center;
        }
        
        button.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
