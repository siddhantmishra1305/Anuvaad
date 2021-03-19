//
//  Date + Extension.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 19/03/21.
//

import Foundation

extension String {
    
    func toDate(format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}

extension Date {
    
    func toString(format: String) -> String? {
        
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    func add(component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    static func allDates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    var dayofTheWeek: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return daysOfTheWeek[dayNumber - 1]
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    private var daysOfTheWeek: [String] {
        return  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
}

