//
//  KeyTableViewController.swift
//  diningHall
//
//  Created by Diwas  Timilsina on 7/12/15.
//  Copyright (c) 2015 Diwas  Timilsina. All rights reserved.
//

import UIKit

class KeyTableViewController: UITableViewController {

    var keyList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.registerClass(MGSwipeTableCell.self, forCellReuseIdentifier: "key_cell")
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        var buttonContainer: UIView = UIView(frame: CGRectMake(100,0, 250, 44))
        //buttonContainer.backgroundColor = UIColor.clearColor()
        //var editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPressed:")
        var addButton: UIButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        //editButton.backgroundColor = UIColor.blueColor()
        //var editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPresed:")
        addButton.setTitle("Add", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Highlighted)
        addButton.addTarget(self, action: "addButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonContainer.addSubview(addButton)
        
        self.navigationController?.toolbar.addSubview(buttonContainer)
            //titleView = buttonContainer

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func addButtonPressed(sender: UIButton){
        let addKey = UIAlertController(title: "Add Key", message: "", preferredStyle: .Alert)
        
        addKey.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "New Key"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        addKey.addAction(cancelAction)
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { action in
            let textField = addKey.textFields!.first! as! UITextField
            self.keyList.append(textField.text.lowercaseString)
            self.tableView.reloadData()
        }
        
        addKey.addAction(postAction)
        presentViewController(addKey, animated: true, completion: nil)

    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return keyList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = self.tableView.dequeueReusableCellWithIdentifier("key_cell") as! UITableViewCell
        cell.textLabel?.text = keyList[indexPath.row].capitalizedString
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            keyList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Action
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        //popoverController.dismissPopoverAnimated(true)
        if keyPopoverViewController != nil {
            keyPopoverViewController.dismissPopoverAnimated(true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
