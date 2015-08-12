//
//  AmigosTableViewController.swift
//  StoryGether
//
//  Created by Vitor on 8/12/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class AmigosTableViewController: UITableViewController {
    
    var tipo:String!
    var array = []

    override func viewDidLoad() {
        super.viewDidLoad()

        println("\(tipo)")
        Model.getAllFollowers(tipo, callback: {
            users in
            self.array = users
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        let user: PFObject = self.array[indexPath.row] as! PFObject
        
        cell.parseObjects = user
        cell.awakeFromNib()
        
        return cell
    }

}
