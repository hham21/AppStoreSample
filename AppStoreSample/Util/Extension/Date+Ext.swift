//
//  Date+Ext.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let calendar: Calendar = .current
        let now: Date = .init()
        let unitFlags: NSCalendar.Unit = [
            .second, .minute, .hour, .day, .weekOfYear, .month, .year
        ]
        let components: DateComponents = (calendar as NSCalendar)
            .components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year) 년 전"
        }
        
        if let year = components.year, year >= 1 {
            return "지난 해"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)달 전"
        }
        
        if let month = components.month, month >= 1 {
            return "지난 달"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)주 전"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "지난 주"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)일 전"
        }
        
        if let day = components.day, day >= 1 {
            return "어제"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)초 전"
        }
        
        return "방금 전"
    }
}
