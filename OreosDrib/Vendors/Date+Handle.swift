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
    
    _dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss"
    
    return _dateFormatter
}()

extension Date {
    static func dribbbleDate(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
