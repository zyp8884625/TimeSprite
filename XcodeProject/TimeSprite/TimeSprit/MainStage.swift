//
//  MainStage.swift
//  TimeSprit
//
//  Created by Yunpeng Zhang on 9/27/16.
//  Copyright © 2016 Yunpeng Zhang. All rights reserved.
//

import Foundation
import UIKit

class MainStage: UITableViewController {
    @IBOutlet var mainStageTableView: UITableView!
    
    @IBOutlet weak var generateCalendar: UITableViewCell!
    
    var task = newTask()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MainStage"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
