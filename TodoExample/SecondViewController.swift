//
//  SecondViewController.swift
//  TodoExample
//
//  Created by Wayne on 1/7/16.
//  Copyright © 2016 Wayne. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let realm = try! Realm()
    
    var tasks :Results<Task>!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadTasks()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadTasks()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel!.text = tasks[indexPath.row].name
        
        return cell
    }



    @IBAction func addNewItem(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "type task name here.."
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Canceled")
        })
        
        let addTaskAction = UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in
            let textField = alertController.textFields![0] as UITextField
            let taskName = textField.text! as String
            
            let task = Task()
            task.name = taskName
            

            try! self.realm.write {
                self.realm.add(task)
            }
        })
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(addTaskAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: .Normal, title: "Mark as uncompleted") { action, index in
            let task = self.tasks[indexPath.row]
            
            try! self.realm.write {
                task.isCompleted = false
            }
            
            self.loadTasks()
            self.tableView.reloadData()
        }
        doneAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action, index in
            let task = self.tasks[indexPath.row]
            
            
            try! self.realm.write {
                self.realm.delete(task)
            }
            
            self.loadTasks()
            self.tableView.reloadData()
        }
        
        return [deleteAction, doneAction]
    }
    
    
    func loadTasks() {
        tasks = realm.objects(Task).filter("isCompleted == 1")
    }
}

