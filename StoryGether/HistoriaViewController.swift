//
//  HistoriaViewController.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class HistoriaViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var historiaTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloTextField.espacoInicial();
        historiaTextView.text = "Comece uma história"
        historiaTextView.textColor = UIColor.lightGrayColor()
        
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        historiaTextView.text = ""
        historiaTextView.textColor = UIColor.blackColor()
        return true;
    }
    func textViewDidChange(textView: UITextView) {
        var texto: String = textView.text
        if(count(texto)==0){
            historiaTextView.text = "Comece uma história"
            historiaTextView.textColor = UIColor.lightGrayColor()
            historiaTextView.resignFirstResponder()
        }
    }
    @IBAction func cancelarNovaHistoria(sender: AnyObject) {
        
        (self.tabBarController as! TabBarController).showTabBar(true)
    }
    
    @IBAction func saveHistoria(sender: AnyObject) {
        
        let className = PFUser.currentUser()?.parseClassName
        
        var trechos: PFObject = PFObject(className: "Trechos")
        trechos["trecho"] = self.historiaTextView.text!
        trechos["escritor"] = PFUser.currentUser()?.valueForKey("profile")
        
        var novahistoria:PFObject = PFObject(className: "Historias")
        novahistoria["titulo"] = self.tituloTextField.text!
        novahistoria["criador"] = PFUser.currentUser()?.valueForKey("profile")
        novahistoria["trechoInicial"] = self.historiaTextView.text!
        
        let user = PFUser.currentUser()!
        if var historias = user["historias"] as? [PFObject]{
            
            historias.append(novahistoria)
            user["historias"] = historias
        } else { user["historias"] = [novahistoria] }
        
        user.saveInBackgroundWithBlock({
            (sucess, error) -> Void in
            if error != nil {
                // There was an error.
                print("erro em salvar historia.")
            }else {
                print("historia salva. \(sucess)")
                trechos["historia"] = novahistoria.objectId!
                trechos.saveInBackground()
            }
        })
        
        (self.tabBarController as! TabBarController).showTabBar(true)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

}
