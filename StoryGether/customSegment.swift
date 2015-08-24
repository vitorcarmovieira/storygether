//
//  customSegment.swift
//  StoryGether
//
//  Created by Vitor on 8/24/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation

class customSegment{
    
    private var segmentView: SMSegmentView!
    
    init(spaceSegment: CGRect){
        
        self.segmentView = SMSegmentView(frame: spaceSegment , separatorColour: UIColor(white: 0.4, alpha: 1.0), separatorWidth: 0.5, segmentProperties: [keySegmentOnSelectionTextColour: UIColor().colorWithHexString("1083B1"),keySegmentTitleFont: UIFont.systemFontOfSize(12.0), keySegmentOnSelectionColour: UIColor.whiteColor(), keySegmentOffSelectionColour: UIColor.whiteColor(), keyContentVerticalMargin: Float(10.0)])
        
        self.segmentView.layer.cornerRadius = 5.0
        self.segmentView.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor
        self.segmentView.layer.borderWidth = 1.0
        
        // Add segments
        self.segmentView.addSegmentWithTitle("Histórias Criadas", onSelectionImage: UIImage(named: "criada_selec"), offSelectionImage: UIImage(named: "criada"))
        self.segmentView.addSegmentWithTitle("Colaborações", onSelectionImage: UIImage(named: "colabora_selec"), offSelectionImage: UIImage(named: "colabora"))
        self.segmentView.addSegmentWithTitle("Favoritadas", onSelectionImage: UIImage(named: "fav_selec"), offSelectionImage: UIImage(named: "fav"))
        
        // Set segment with index 0 as selected by default
        segmentView.selectSegmentAtIndex(0)
    }
    
    func segment() -> SMSegmentView{
        return self.segmentView
    }
    
}
