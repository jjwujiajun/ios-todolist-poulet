//
//  Funtionalities.swift
//  Poulet
//
//  Created by Jiajun Wu on 9/11/15.
//  Copyright (c) 2015 Jiajun Wu. All rights reserved.
//

import Foundation

class Functionalities {
    
    struct Time {
        static let Minute:Double = 60
        static let Hour:Double = 60 * Minute
        static let Day:Double = 24 * Hour
        static let Week:Double = 7 * Day
        static let unitsArray = [0, Minute, Hour, Day, Week]
    }
    
    static let Period_Singular = ["", "minute", "hour", "day", "week", "month"]
    static let Period_Plural = ["", "minutes", "hours", "days", "weeks", "months"]
    
    static let WeekDay = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    static let Month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    struct Notification {
        static let ReminderDone = "reminderDone"
        
        static let CellIndexPath = "cellIndexPath"
    }
    
    struct Entity {
        static let Reminder = "Reminder"
        static let Reminder_sortKey = "dueDue"
    }
    
    static func dateFormatter(timeLabelDate: NSDate) -> String {
        var dateString: String? = ""
        if let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
            var timeFromNow = timeLabelDate.timeIntervalSinceNow
            
            if timeFromNow < 0 {
                dateString = "Due "
            }
            
            if abs(timeFromNow) < 2 * Time.Hour {
                if timeFromNow > 0 {
                    dateString = "In "
                }
                if Int(timeFromNow/Time.Hour) != 0 {
                    dateString = dateString! + "\(Int(abs(timeFromNow)/Time.Hour)) hours "
                    timeFromNow = timeFromNow%Time.Hour
                }
                if timeFromNow != 0 {
                    dateString = dateString! + "\(Int(abs(timeFromNow)/Time.Minute)) minutes "
                }
                if timeFromNow < 0 {
                    dateString? += "ago"
                }
            } else {
                let dateToday = gregorian.component(.Day, fromDate: NSDate())
                let dateSet = gregorian.component(.Day, fromDate: timeLabelDate)
                
                if timeFromNow > 0 {
                    if dateSet == dateToday {
                        dateString = "Today"
                    } else if dateSet - 1 == dateToday {
                        dateString = "Tomorrow"
                    } else if timeFromNow < 1 * Time.Week {
                        let weekday = gregorian.component(.Weekday, fromDate: timeLabelDate)
                        dateString = "On " + WeekDay[weekday - 1]
                    } else {
                        let month = gregorian.component(.Month, fromDate: timeLabelDate)
                        let date = gregorian.component(.Day, fromDate: timeLabelDate)
                        dateString = "On " + Month[month - 1] + " \(date)"
                    }
                } else {
                    if dateSet == dateToday - 1 {
                        dateString? += "yesterday"
                    } else {
                        let month = gregorian.component(.Month, fromDate: timeLabelDate)
                        let date = gregorian.component(.Day, fromDate: timeLabelDate)
                        dateString? += Month[month - 1] + " \(date)"
                    }
                }
                let hour = gregorian.component(.Hour, fromDate: timeLabelDate)
                let minute = gregorian.component(.Minute, fromDate: timeLabelDate)
                var minuteString = ""
                if minute < 10 {
                    minuteString = "0" + "\(minute)"
                } else {
                    minuteString = "\(minute)"
                }
                dateString = (dateString ?? "") + " at \(hour):" + minuteString
            }
        }
        return dateString ?? ""
    }
}