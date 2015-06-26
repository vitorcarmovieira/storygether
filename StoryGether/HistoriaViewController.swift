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

        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveHistoria(sender: AnyObject) {
        
        var historias:PFObject = PFObject(className: "Historias")
        historias["titulo"] = self.tituloTextField.text!
        
        historias.saveInBackground()
        
        var query: PFQuery = PFQuery(className: "Historias")
        
        query.whereKey("titulo", equalTo: self.tituloTextField.text!)
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) ->Void in
        
            if error == nil{
                if let historias = objects as? NSArray {
                
                    for historia in historias {
                    
                        println("\(historia)")
                        
                        let h: PFObject = historia as! PFObject
                        
                        var trechos: PFObject = PFObject(className: "Trechos")
                        trechos["texto"] = self.historiaTextView.text!
                        trechos["escritor"] = h.valueForKey("objectId") as! String
                        
                        trechos.saveInBackground()
                    }
                }
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
