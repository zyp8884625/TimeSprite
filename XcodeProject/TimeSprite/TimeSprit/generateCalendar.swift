//
//  generateCalendar.swift
//  TimeSprit
//
//  Created by Yunpeng Zhang on 11/14/16.
//  Copyright © 2016 Yunpeng Zhang. All rights reserved.
//

import Foundation
import UIKit
import EventKitUI

class generateCalendar: UIViewController {
    @IBOutlet weak var generateProgress: UIProgressView!
    
    @IBOutlet weak var okButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        progress()
    }
    
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
    var eventStore = EKEventStore()
    
    func progress() {
        //generateProgress.progress = 0.00
        for i in 0 ..< 100{
            
            DispatchQueue.main.async(execute: {
                self.generateProgress.setProgress(Float(i) / 100.00, animated: true)
            })
            sleep(UInt32(0.1))
        }
        
        processEventFile()
    }
    
    func processEventFile() {
        let file = NSTemporaryDirectory() + "/eventsFile.txt" //this is the file. we will write to and read from it
        print(file)
        
        let manager = FileManager.default
        let data = manager.contents(atPath: file)
        let readString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        var eventStringList = readString!.components(separatedBy: "\n")
        
        eventStringList.removeLast()
        for eventString in eventStringList{
            var tempEvent = CalendarEvent()
            var eventAttList = eventString.components(separatedBy: ",")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY:MM:dd:HH:mm"
            
            tempEvent.name = eventAttList[0]
            tempEvent.description = eventAttList[1]
            tempEvent.startTime = dateFormatter.date(from: eventAttList[2])!
            tempEvent.endTime = dateFormatter.date(from: eventAttList[3])!
            tempEvent.Estimated = eventAttList[4]
            if eventAttList[5] == "T"{
                tempEvent.divided = true
            }else{
                tempEvent.divided = false
            }
            
            eventList.append(tempEvent)
            requestAccessToCalendar()
            processEventObj(temp: tempEvent)
        }
        print("eventList")
        print(eventList)
        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    print("a")
                })
            } else {
                DispatchQueue.main.async(execute: {
                    print("b")
                })
            }
        })
    }
    
    func processEventObj(temp:CalendarEvent) {

        //let EKcalendar = EKCalendar(for: EKEntityType.event, eventStore: eventStore)

        var smallEventList:[CalendarEvent] = []
        
        
        if temp.divided{
            // Read profile
            let file = NSTemporaryDirectory() + "/profile.txt"
            let manager = FileManager.default
            let data = manager.contents(atPath: file)
            let readString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            print("Relax")
            print(readString)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            var startRelaxTime = dateFormatter.date( from: readString!.components(separatedBy: ",")[0] )
            var endRelaxTime = dateFormatter.date( from: readString!.components(separatedBy: ",")[1] )
            
            var period = daysBetweenDates(startDate: temp.startTime, endDate: temp.endTime)
        
            if period == 0{ // if Start date and end date are same
                period = 1
            }
        
            var smallEventTime = 0.0
            
            var endRelaxTimeComponents = NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: endRelaxTime!)
            let startDateComponents = NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: temp.startTime)
            
            endRelaxTimeComponents.day = startDateComponents.day
            endRelaxTimeComponents.year = startDateComponents.year
            endRelaxTimeComponents.month = startDateComponents.month
            endRelaxTimeComponents.timeZone = TimeZone(identifier: "UTC")
            
            endRelaxTime = NSCalendar.current.date(from: endRelaxTimeComponents)
            
            //let dateComparisionResult: ComparisonResult = (endRelaxTime?.compare(dateFormatter.date(from: dateFormatter.string(from: temp.startTime))!))!
            
            if (Double(temp.Estimated) != nil){
                smallEventTime = Double(temp.Estimated)! / Double(period)
            }
            
            for i in 0...period - 1 {
                let startTime = NSDateComponents()
                startTime.year = startDateComponents.year!
                startTime.month = startDateComponents.month!
                startTime.day = startDateComponents.day! + i
                startTime.hour = endRelaxTimeComponents.hour!
                startTime.minute = endRelaxTimeComponents.minute!
                startTime.timeZone = TimeZone(identifier: "UTC")
                
                let startTimeDate = NSCalendar.current.date(from: startTime as DateComponents)
                
                var endTimeDate = Date()
                if smallEventTime < 1 {
                    endTimeDate = NSCalendar.current.date(byAdding: .minute, value: Int(smallEventTime * 60.00), to: startTimeDate!)!
                }else{
                    endTimeDate = NSCalendar.current.date(byAdding: .hour, value: Int(smallEventTime), to: startTimeDate!)!
                }
                
                var smallEventTemp = CalendarEvent()
                
                smallEventTemp.name = temp.name
                smallEventTemp.description = temp.description
                smallEventTemp.startTime = startTimeDate!
                smallEventTemp.endTime = endTimeDate
                
                print("smallEvent")
                print(smallEventTemp)
                smallEventList.append(smallEventTemp)

            }
        }
        for event in smallEventList{
            let newEvent = EKEvent(eventStore: eventStore)
            
            newEvent.calendar = eventStore.defaultCalendarForNewEvents
            newEvent.title = event.name
            //newEvent.description = event.description
            newEvent.startDate = event.startTime
            newEvent.endDate = event.endTime
            newEvent.timeZone = TimeZone(identifier: "UTC")
            
            print(newEvent)
            
            do {
                try eventStore.save(newEvent, span:EKSpan.thisEvent, commit: true)
            }
            catch {/* error handling here */}
        }
        reNewEventFile()
    }
    
    func reNewEventFile() {
        let file = NSTemporaryDirectory() + "/eventsFile.txt"
        let text = ""
        do {
            try text.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {/* error handling here */}
    }
}
