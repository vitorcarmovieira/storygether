//
//  TabBarController.swift
//  StoryGether
//
//  Created by Vitor on 6/4/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabBarAppearace = UITabBar.appearance()
        
        tabBarAppearace.tintColor = UIColor.whiteColor()
        tabBarAppearace.barTintColor = UIColor.whiteColor()
        
        let tabBar = self.tabBar
        
        var tabBarItemTimeLine = tabBar.items![0] as! UITabBarItem
        var tabBarItemPerfil = tabBar.items![2] as! UITabBarItem
        
        tabBarItemTimeLine.image = UIImage(named: "tabbar_icon_feed")!.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItemTimeLine.selectedImage = UIImage(named: "tabbar_icon_feed_clique")!.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItemPerfil.image = UIImage(named: "tabbar_icon_perfil")!.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItemPerfil.selectedImage = UIImage(named: "tabbar_icon_perfil_clique")!.imageWithRenderingMode(.AlwaysOriginal)
        
        let buttonImage: UIImage? = UIImage(named: "tabbar_icon_criar")
        let buttonSelectedImage = UIImage(named: "tabbar_icon_clique_07")
        
        button = UIButton(frame: CGRectMake(0.0, 0.0, buttonImage!.size.width - 75, buttonImage!.size.height - 75))
        button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.setBackgroundImage(buttonSelectedImage, forState: UIControlState.Selected)
        
        let heightDifference: CGFloat = buttonImage!.size.height - self.tabBar.frame.size.height
        if heightDifference < 0 {
            
            button.center = self.tabBar.center
        } else{
            
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/3.5
            button.center = center;
        }
        
        button.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClicked(){
        
        var view: HistoriaViewController = storyboard?.instantiateViewControllerWithIdentifier("criaHistoria") as! HistoriaViewController
        showTabBar(false)
    }
    
    func showTabBar(visible: Bool){
        self.selectedIndex = visible ? 0 : 1
        setTabBarVisible(visible, animated: true)
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        let frameb = self.button.frame
        let heightb = frameb.size.height+frame.size.height/2
        let offsetYb = (visible ? -heightb : heightb)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if !frame.isNull {
            UIView.animateWithDuration(duration) {
                self.tabBar.frame = CGRectOffset(frame, 0, offsetY)
                self.button.frame = CGRectOffset(frameb, 0, offsetYb)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
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
