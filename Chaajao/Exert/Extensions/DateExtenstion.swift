
import Foundation
import UIKit
extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}


extension Date {
    
    static func date(fromDay day: Int, month: Int, year: Int) -> Date {
        var calendar = Calendar.current
        var components = DateComponents()
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        components.day = day
        if month <= 0 {
            components.month = 12 - month
            components.year = year - 1
        }
        else if month >= 13 {
            components.month = month - 12
            components.year = year + 1
        }
        else {
            components.month = month
            components.year = year
        }
        return dateWith(noTime: calendar.date(from: components)!, middleDay: false)
    }

    static func dateWith(noTime dateTime: Date, middleDay middle: Bool) -> Date {
      
        var calendar = Calendar.current
        calendar.timeZone =  TimeZone(identifier: "UTC")!
        var components = DateComponents()

        components = calendar.dateComponents([.day, .month, .year, .hour], from:dateTime)
        var dateOnly: Date? = calendar.date(from: components)
        if middle {
            dateOnly = dateOnly?.addingTimeInterval((60.0 * 60.0 * 12.0))
        }
        // Push to Middle of day.
        return dateOnly!
    }
    func numberOfDaysInMonth() -> Int {
        let c = Calendar.current
        let days = c.range(of:.day, in: .month, for:self)
        return (days?.count)!
    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}
