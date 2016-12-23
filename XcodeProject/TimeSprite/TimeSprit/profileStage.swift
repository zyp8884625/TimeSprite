//
//  profileStage.swift
//  TimeSprit
//
//  Created by Yunpeng Zhang on 9/27/16.
//  Copyright © 2016 Yunpeng Zhang. All rights reserved.
//

import Foundation
import UIKit
class profileStage: UITableViewController {
    @IBOutlet weak var relextimeEndtimePicker: UIDatePicker!
    @IBOutlet weak var relextimeStarttimePicker: UIDatePicker!
    @IBOutlet var profileStageTable: UITableView!
    @IBOutlet weak var profileSaveButton: UIButton!
    
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        let file:String = NSTemporaryDirectory() + "/profile.txt" //this is the file. we will write to and read from it
        
        var text = "" //just a text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        text += dateFormatter.string(from: relextimeStarttimePicker.date)
        text += ","
        text += dateFormatter.string(from: relextimeEndtimePicker.date)
        
        print(text)
        
            
            //writing
        do {
            try text.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {/* error handling here */}
        
        let fileManager = FileManager.default
        let fileArray = fileManager.subpaths(atPath: NSTemporaryDirectory())
        
        print(fileArray as Any)
        
    }
    
    func reNewEventFile() {
        let file = NSTemporaryDirectory() + "/eventsFile.txt"
        let text = ""
        do {
            try text.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {/* error handling here */}
    }
    
    override func viewDidLoad() {
        reNewEventFile()
    }
}
