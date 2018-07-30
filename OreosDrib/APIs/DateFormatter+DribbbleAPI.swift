//
//  DateFormatter+DribbbleAPI.swift
//  OreosDrib
//
//  Created by P36348 on 30/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation

public let apiDateFormatter: DateFormatter = {
    let _formatter: DateFormatter = DateFormatter()
    
    /**
     * 根据dribbble要求格式化
     */
    _formatter.dateFormat = "YYYY-MM-dd"
    
    /**
     * 时区转换为西四区
     */
    _formatter.timeZone = TimeZone(secondsFromGMT: -4 * 60 * 60)
    return _formatter
}()
