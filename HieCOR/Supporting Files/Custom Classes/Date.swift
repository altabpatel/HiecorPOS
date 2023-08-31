//
//  Date.swift
//  HieCOR
//
//  Created by Deftsoft on 16/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//


import Foundation


//MARK: Enumeration
enum WeekDay: String {
    case Mo
    case Tu
    case We
    case Th
    case Fr
    case Sa
    case Su
    static let weekArray = [Mo, Tu, We, Th, Fr, Sa, Su]
}

enum TimeZoneType {
    case gmt
    case utc
    case local
}

enum DateFormat: String {
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case dateTime24 = "yyyy-MM-dd hh:mm:ss"
    case dateTime12 = "yyyy-MM-dd hh:mm a"
    case mdyDate = "MM-dd-yyyy"
    case InvoiceyDate = "MM/dd/yyyy"
    case mdyDateTime = "MM/dd/yyyy HH:mm:ss"
    case ymdDate = "yyyy-MM-dd"
    case dmyDate = "dd-MM-yyyy"
    case shortMDYDate = "MMM-dd-yyyy"
    case shortDMYDate = "dd-MMM-yyyy"
    case longDMYData = "EEEE dd MMM yyyy"
    case longTime = "HH:mm:ss"
    case longTime12 = "hh:mm:ss"
    case newSimpleMonth = "YYYY-MM"
    case newSimpleDate = "YYYY-MM-dd"
    case newDateTime = "dd, MMMM yyyy hh:mm a"
    case newDateTime1 = "dd MMM yyyy HH:mm:ss"
    case newDateTime2 = "dd MMM yyyy, EEEE"
    case newDate = "dd, MMMM yyyy"
    case time = "hh:mm a"
}

extension Date {

    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func timeAgoSinceDate(date: Date) -> String {
        let earliest = (date as NSDate).earlierDate(self)
        let latest = (earliest == date) ? self : date
        let components:DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        
        if components.minute! == 5 {
            return "5 minutes before"
        }
        if components.minute! == 15 {
            return "15 minutes before"
        }
        if components.minute! == 30 {
            return "30 minutes before"
        }
        if components.hour! == 1 {
            return "1 hour before"
        }
        if components.hour! == 2 {
            return "2 hour before"
        }
        if components.day! == 1 {
            return "1 day before"
        }
        if components.day! == 2 {
            return "2 days before"
        }
        return "\(components.hour!) hours before"
    }
    
    
    func stringFromDate(format: DateFormat, type: TimeZoneType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        if type == .utc {
            dateFormatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        }
        else if type == .gmt {
            dateFormatter.timeZone = (NSTimeZone(name: "GMT")! as TimeZone)
        }
        else {
            dateFormatter.timeZone = NSTimeZone.local
        }
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingDays(inDays:NSInteger)->Date {
        return Calendar.current.date(byAdding: .day, value: inDays, to: self)!
    }
    
    func dateByAddingWeek(inDays:NSInteger)->Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: inDays, to: self)!
    }
    
    var millisecondsSince1970: Double {
        return self.timeIntervalSince1970 * 1000.0
    }
    
    init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000.0))
    }
    
    func addHoursInDate(hoursToAdd:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: hoursToAdd, to: self)!
    }
    
    func addMinutesInDate(minutesToAdd:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: minutesToAdd, to: self)!
    }
    
    func previousMinutesToDate(minutesToBack:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: -minutesToBack, to: self)!
    }

    func addSecondsInDate(secondsToAdd:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: secondsToAdd, to: self)!
    }
    
    func addDaysinDate(daysToAdd:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: daysToAdd, to: self)!
    }
    
    func previousDaysFromDate(daysToBack:Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -daysToBack, to: self)!
    }

    func getMonth(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
}

extension Double {
    
    var dateFromMiliSeconds: Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
    
}

extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> (String, String) {
        if years(from: date)   > 0 { return ("\(years(from: date)) years before", "Starts in \(years(from: date)) years")   }
        if months(from: date)  > 0 { return ("\(months(from: date)) months before","Starts in \(months(from: date)) months")  }
        if weeks(from: date)   > 0 { return ("\(weeks(from: date)) weeks before","Starts in \(weeks(from: date)) weeks")   }
        if days(from: date)    > 0 { return ("\(days(from: date)) days before", "Starts in \(days(from: date)) days")    }
        if hours(from: date)   > 0 { return ("\(hours(from: date)) hours before", "Starts in \(hours(from: date)) hours")   }
        if minutes(from: date) > 0 { return ("\(minutes(from: date)) minutes before","Starts in \(minutes(from: date)) minutes"
            )}
        if seconds(from: date) > 0 { return ("\(seconds(from: date)) seconds before", "Starts in \(seconds(from: date)) seconds") }
        return ("", "")
    }
    
}
