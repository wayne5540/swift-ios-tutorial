//
//  FirstViewController.swift
//  TodoExample
//
//  Created by Wayne on 1/7/16.
//  Copyright © 2016 Wayne. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks :Results<Task>!
    
    
    

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
        // 定義 alertController, UIAlertController 就是之後會跳出來的 Popup View
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        // 加上一個 Input 的 TextField 框框讓使用者輸入 Task Name
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "type task name here.."
        })
        
        
        // 定義這個 Alert Popup 會有哪些動作，此例我們只需要 Cancel 和 Add
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            // handler 裡面的 code 代表使用者按了這個 Action 以後要處理的事情。
            print("Canceled")
        })
        
        let addTaskAction = UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in
            let textField = alertController.textFields![0] as UITextField
            let taskName = textField.text! as String
            
            // 初始化 Task 的 Object
            let task = Task()
            task.name = taskName

            // 將 Task 寫進資料庫
            try! self.realm.write {
                self.realm.add(task)
            }
            
            self.loadTasks()
            self.tableView.reloadData()
        })
        
        
        // 把剛剛定義好的 Action 塞到 Alert 的 Popup 裡面
        alertController.addAction(cancelAction)
        alertController.addAction(addTaskAction)
        
        // 將前面設定好的 Alert View 顯示出來
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: .Normal, title: "Mark as completed") { action, index in
            let task = self.tasks[indexPath.row]
            
            try! self.realm.write {
                task.isCompleted = true
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
        tasks = realm.objects(Task).filter("isCompleted == 0")
    }
}

