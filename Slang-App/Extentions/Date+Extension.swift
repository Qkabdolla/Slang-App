//
//  Date+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

extension Date {
	static func getDate(fromString dateString: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		return dateFormatter.date(from: dateString) ?? Date()
	}
	
	static func getPrettyDateString(fromString dateString: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy"
		
		let date = getDate(fromString: dateString)
		
		return dateFormatter.string(from: date)
	}
	
	static func getPrettyDateString(fromDate date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, yyyy"
		
		return dateFormatter.string(from: date)
	}
}
