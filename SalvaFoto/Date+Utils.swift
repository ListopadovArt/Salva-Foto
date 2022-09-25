//
//  Date+Utils.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 25.09.22.
//

import Foundation


extension Date {
    static var salvaFotoDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        return formatter
    }
    
    var monthDayYearString: String {
        let dateFormatter = Date.salvaFotoDateFormatter
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
