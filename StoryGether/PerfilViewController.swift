//
//  PerfilViewController.swift
//  StoryGether
//
//  Created by Vitor on 7/20/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class PerfilViewController: UIViewController, UsuarioDelegate, UITableViewDataSource, UITableViewDelegate, SMSegmentViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var numSeguidores: UILabel!
    @IBOutlet weak var numSeguindo: UILabel!
    @IBOutlet weak var spaceSegment: UIView!
    var iAmSelected: Int = 0
    var historias:[Historia]!
    var usuario: Usuario!
    var segmentView: SMSegmentView!
    var margin: CGFloat = 10.0
    
    override func viewDidLoad() {
        
        self.usuario = Usuario.currentUser
        self.usuario.delegate = self
        
        self.historias = []
        self.imagemView.circularImageView()
        self.tableView.delegate = self
        
        self.imagemView.text = self.usuario.parseToDictionary()["urlFoto"] ?? ""
        self.nomeLabel.text = self.usuario.parseToDictionary()["nome"]
        self.segmentView = SMSegmentView(frame:self.spaceSegment.frame , separatorColour: UIColor(white: 0.4, alpha: 1.0), separatorWidth: 0.5, segmentProperties: [keySegmentOnSelectionTextColour: UIColor().colorWithHexString("1083B1"),keySegmentTitleFont: UIFont.systemFontOfSize(12.0), keySegmentOnSelectionColour: UIColor.whiteColor(), keySegmentOffSelectionColour: UIColor.whiteColor(), keyContentVerticalMargin: Float(10.0)])
        
        self.segmentView.delegate = self
        
        self.segmentView.layer.cornerRadius = 5.0
        self.segmentView.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor
        self.segmentView.layer.borderWidth = 1.0
        
        // Add segments
        self.segmentView.addSegmentWithTitle("Histórias Criadas", onSelectionImage: UIImage(named: "criada_selec"), offSelectionImage: UIImage(named: "criada"))
        self.segmentView.addSegmentWithTitle("Colaborações", onSelectionImage: UIImage(named: "colabora_selec"), offSelectionImage: UIImage(named: "colabora"))
        self.segmentView.addSegmentWithTitle("Favoritadas", onSelectionImage: UIImage(named: "fav_selec"), offSelectionImage: UIImage(named: "fav"))
        
        // Set segment with index 0 as selected by default
        segmentView.selectSegmentAtIndex(0)
        
        self.usuario.getAllHistorias()
        
        self.view.addSubview(self.segmentView)
    }
    
    // SMSegment Delegate
    func segmentView(segmentView: SMSegmentView, didSelectSegmentAtIndex index: Int) {
        /*
        Replace the following line to implement what you want the app to do after the segment gets tapped.
        */
        println("Select segment at index: \(index)")
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        /*
        MARK: Replace the following line to your own frame setting for segmentView.
        */
        if toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight {
            self.segmentView.organiseMode = .SegmentOrganiseVertical
            self.segmentView.segmentVerticalMargin = 25.0
            self.segmentView.frame = CGRect(x: self.view.frame.size.width/2 - 40.0, y: 100.0, width: 80.0, height: 220.0)
        }
        else {
            self.segmentView.organiseMode = .SegmentOrganiseHorizontal
            self.segmentView.segmentVerticalMargin = 10.0
            self.segmentView.frame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
        }
    }
    
    func didChangeStories() {
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PerfilHistoriaCell
        
        cell.historia = self.usuario.getAllHistorias()[indexPath.row]
        cell.awakeFromNib()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.usuario.getAllHistorias().count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCellWithIdentifier("HeaderCellQuatidades") as! PerfilNumeroHistorias
        
        header.labelNumHistorias.text = "\(self.historias.count)"
        header.labelDescricao.text = NSLocalizedString("Stories created",comment: "title to show story created by you")
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let height = 40.0 as CGFloat
        
        return height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height = 60.0 as CGFloat
        
        return height
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "followers"{
            
            let view = segue.destinationViewController as? AmigosTableViewController
            view?.tipo = "followers"
            
        }else{
            let view = segue.destinationViewController as? AmigosTableViewController
            view?.tipo = "following"
        }
    }
}
