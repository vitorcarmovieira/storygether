//
//  PerfilViewController.swift
//  StoryGether
//
//  Created by Vitor on 7/20/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse
import CoreData

class PerfilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var numSeguidores: UILabel!
    @IBOutlet weak var numSeguindo: UILabel!
    @IBOutlet weak var buttonHistorias: UIButton!
    @IBOutlet weak var buttonFinalizadas: UIButton!
    @IBOutlet weak var buttonCoop: UIButton!
    @IBOutlet weak var buttonFavoritas: UIButton!
    var iAmSelected: Int = 0
    var historias:[Historias]!
    
    override func viewDidLoad() {
        
        self.historias = []
        self.imagemView.circularImageView()
        self.buttonHistorias.selected = true
        self.tableView.delegate = self
      
        if let user = Usuarios.getCurrent(){
            
            self.imagemView.image = UIImage(data: user.foto)
            self.nomeLabel.text = user.nome
            
            self.historias = user.historias.allObjects as! [Historias]
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PerfilHistoriaCell
        
        cell.historia = self.historias[indexPath.row]
        cell.awakeFromNib()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historias.count
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
    
    
    @IBAction func changeToHistorias(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 0;
        self.buttonHistorias.selected = true
        
        self.historias = Usuarios.getCurrent()?.historias.allObjects as! [Historias]
        self.tableView.reloadData()
    }
    
    @IBAction func changeToFavoritas(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 3;
        self.buttonFavoritas.selected = true
        
        self.historias = Usuarios.getCurrent()?.favoritas.allObjects as! [Historias]
        self.tableView.reloadData()
    }
    
    @IBAction func changeToFinalizadas(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 1;
        self.buttonFinalizadas.selected = true
    }
    
    @IBAction func changeToCoop(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 2;
        self.buttonCoop.selected = true
    }
    
    func isSomeButtonSelected(c: Int){
        
        switch c{
        case 0:
            self.buttonHistorias.selected = false
        case 1:
            self.buttonFinalizadas.selected = false
        case 2:
            self.buttonCoop.selected = false
        case 3:
            self.buttonFavoritas.selected = false
        default:
            print("Error")
        }
    }
}
