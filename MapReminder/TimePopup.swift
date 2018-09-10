//
//  PlaceMarker.swift
//  MapReminder
//
//  Created by Rajat Chaudhary on 08/09/18.
//  Copyright © 2018 Rajat Chaudhary. All rights reserved.
//

import UIKit
import EventKit
import GoogleMaps

class TimePopup: UIViewController {
    @IBOutlet var timePicker: UIDatePicker!
    var marker: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.datePickerMode = .time
    }
    
    
    @IBAction func createEvent(_ sender: Any) {
        let time = timePicker.date
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (isGranted, error) in
            if isGranted {
                let reminder = EKEvent(eventStore: eventStore)
                reminder.title = "Hvae to Go to"
                reminder.notes = self.marker
                let tenMinBefore = time.addingTimeInterval(-600)
                let tenMinBeforeAlarm = EKAlarm(absoluteDate: tenMinBefore)
                reminder.addAlarm(tenMinBeforeAlarm)
                let alarm = EKAlarm(absoluteDate: time)
                reminder.addAlarm(alarm)
                reminder.startDate = Date()
                reminder.endDate = Date()
                reminder.calendar = eventStore.defaultCalendarForNewEvents
                let alertBox = UIAlertController(title: "Reminder", message: "message has been added", preferredStyle: UIAlertControllerStyle.alert)
                alertBox.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    if action.style == .default {
                        self.dismiss(animated: true)
                    }
                }))
                self.present(alertBox, animated: true)
                do {
                    try eventStore.save(reminder, span: .thisEvent)
                }
                catch (let error1){
                    print("Some issue while savinf event\(error1)")
                }
            }
            else {
                print("error whilw gtting Access is \(error?.localizedDescription)")
            }
        }
    }
}
