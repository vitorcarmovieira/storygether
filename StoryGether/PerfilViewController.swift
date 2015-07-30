//
//  PerfilViewController.swift
//  StoryGether
//
//  Created by Vitor on 7/20/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var numSeguidores: UILabel!
    @IBOutlet weak var numSeguindo: UILabel!
    @IBOutlet weak var buttonHistorias: UIButton!
    @IBOutlet weak var buttonFinalizadas: UIButton!
    @IBOutlet weak var buttonCoop: UIButton!
    @IBOutlet weak var buttonFavoritas: UIButton!
    var iAmSelected: Int = -1
    
    override func viewDidLoad() {
        
        self.imagemView.circularImageView()
        
        let currentUser: AnyObject? = PFUser.currentUser()?.valueForKey("profile")
        
        self.nomeLabel.text = currentUser?.valueForKey("name") as? String
        
        let url = currentUser?.valueForKey("urlFoto") as? String
        
        //async para pegar foto do usuario
        self.imagemView.getImageAssync(url!)
        
    }
    
    @IBAction func changeToHistorias(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 0;
        self.buttonHistorias.selected = true
    }
    
    @IBAction func changeToFavoritas(sender: AnyObject) {
        
        self.isSomeButtonSelected(self.iAmSelected)
        self.iAmSelected = 3;
        self.buttonFavoritas.selected = true
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
            break
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
