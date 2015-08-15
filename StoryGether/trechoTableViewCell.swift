//
//  trechoTableViewCell.swift
//  StoryGether
//
//  Created by Vitor on 6/19/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class trechoTableViewCell: UITableViewCell {
    
    typealias dic = [String : String?]

    @IBOutlet weak var trechoLabel: UILabel!
    @IBOutlet weak var imagemEscritorTrecho: UIImageView!
    @IBOutlet weak var buttonFavoritar: UIButton!
    @IBOutlet weak var numFavoritadas: UILabel!
    var trecho = dic()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagemEscritorTrecho.circularImageView()
        
        if let trechoText = trecho["trecho"]{
            self.trechoLabel.text = trechoText
        }
        if let objectId = trecho["objectId"]{
            countFavoritadas(objectId!)
        }
        if let url = trecho["urlFoto"]{
            self.imagemEscritorTrecho.setImageAssync(url)
        }
    }
    
    @IBAction func favoritar(sender: AnyObject) {
        
        if let numString = self.numFavoritadas.text{
            let num = (numString as NSString).integerValue
            self.numFavoritadas.text = (num + 1).description
            self.buttonFavoritar.selected = true
        }
        
        if let objectId = trecho["objectId"]!{
            Model.favoritar(objectId, block: {
                bool in
                if bool{
                    
                }
            })
        }
    }
    
    func countFavoritadas(objectId: String){
        
        Model.countInClassName("favoritadas", collum: "historiaId", objectId: objectId, isPointer: false, completion: {
            num in
            self.numFavoritadas.text = num
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
