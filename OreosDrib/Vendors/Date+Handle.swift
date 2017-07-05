//
//  Date+Handle.swift
//  OreosDrib
//
//  Created by P36348 on 2/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let _dateFormatter = DateFormatter()
    
    _dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    _dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
    return _dateFormatter
}()

private var interval: Double {
    return Double(TimeZone.current.secondsFromGMT())
}


/**
 * "2015-07-06T04:30:50Z" 年月日 时分秒 时区
 */

extension Date {
    
    /// dribbble格式字符串对应的日期 时区为GMT0
    ///
    /// - Parameter string: dribbble日期字符串
    /// - Returns: 对应日期
    static func dribbbleDate(string: String) -> Date? {
        let _string = string.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        
        return dateFormatter.date(from: _string)
    }
    
    
    /// 当前时区的日期
    var dateAtCurrentZone: Date {
        return Date(timeInterval: interval, since: self)
    }
    
}
