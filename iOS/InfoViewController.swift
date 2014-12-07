//
//  InfoViewController.swift
//  iOS
//
//  Created by Alejandro Perezpaya on 07/12/14.
//  Copyright (c) 2014 Authy. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {
    
    let kCellIdentifier = "cell"
    var storage: Storage?
    var api: Api?
    
    var providers: [AnyObject]?
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        self.title = "Providers"
        super.viewDidLoad()
        self.storage = Storage()
        self.api = Api(domain: self.storage!.getString("domain"))
        self.loadProviders()
        //self.beacons()
    }
    
    func loadProviders(){
        self.api?.getProviders({ (json: JSON, err) -> () in
            if err != nil {
                println("cannot get providers")
            } else {
                println(json)
                self.providers = json["providers"].arrayObject!
                self.tableView.reloadData()
            }
        })
    }
    
    func resetDomain () {
        self.storage?.store("domain", value: nil)
    }
    
    @IBAction func toggleEdit () {
        self.setEditing(!self.editing, animated: true)
    }
    
    @IBAction func logout () {
        self.api?.logout({
            self.resetDomain()
            var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if self.providers != nil {
            rows = self.providers!.count
        }
        
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell?
        if (cell == nil) {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: kCellIdentifier)
        }
        
        var provider = self.providers?[indexPath.row] as String
        cell!.textLabel?.text = provider
        cell!.detailTextLabel?.text = provider
        cell!.tag = indexPath.row
        cell?.selected = false
        
        return cell!
    }
    
}