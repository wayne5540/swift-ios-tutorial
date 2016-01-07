//
//  FirstViewController.swift
//  TodoExample
//
//  Created by Wayne on 1/7/16.
//  Copyright © 2016 Wayne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func addNewItem(sender: AnyObject) {
    }
}

