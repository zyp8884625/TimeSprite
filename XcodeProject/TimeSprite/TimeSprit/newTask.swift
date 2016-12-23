//
//  newTask.swift
//  TimeSprit
//
//  Created by Yunpeng Zhang on 9/27/16.
//  Copyright © 2016 Yunpeng Zhang. All rights reserved.
//

import Foundation
import UIKit
//import CVCalendar
class newTask: UITableViewController {
    @IBOutlet weak var newTaskTableView: UITableView!
    
    
    @IBOutlet weak var descrpitionField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var cancelB: UIButton!
    @IBOutlet weak var saveB: UIButton!
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var dividedSwitch: UISwitch!
    @IBOutlet weak var EstimatedTime: UITextField!
    
    //----------Event Struct--------
    struct CalendarEvent {
        var name = String()
        var description = String()
        var startTime = Date()
        var endTime = Date()
        var Estimated = String()
        var divided = Bool()
        
    }
    
    var eventList:[CalendarEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTable()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showTable(){
    }
    
    func eventToFile() {
        var text = ""
        
        for event in eventList {
            text += event.name
            text += ","
            text += event.description
            text += ","
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY:MM:dd:HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            text += dateFormatter.string(from: event.startTime)
            text += ","
            text += dateFormatter.string(from: event.endTime)
            text += ","
            text += event.Estimated
            text += ","
            if event.divided {
                text += "T"
            }else
            {
                text += "F"
            }
            text += "\n"
            
        }
        
        print(text)
        
        
        
        let file = NSTemporaryDirectory() + "/eventsFile.txt" //this is the file. we will write to and read from it
        
        let writeHandler = FileHandle(forWritingAtPath:file)!
        writeHandler.seekToEndOfFile()
        
        let appendText = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        writeHandler.write(appendText!)
        
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
        
        var event_need_process = CalendarEvent()
        event_need_process.name = nameField.text!
        event_need_process.description = descrpitionField.text!
        event_need_process.startTime = startTime.date
        event_need_process.endTime = endTime.date
        event_need_process.Estimated = EstimatedTime.text!
        event_need_process.divided = dividedSwitch.isOn

        self.eventList.insert(event_need_process, at: eventList.count)
        eventToFile()
        
    }
}
