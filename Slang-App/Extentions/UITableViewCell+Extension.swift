//
//  UITableViewCell+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var textColor: UIColor {
		switch self {
		case .night: return .white
		case .day: return .black
		}
	}
	
	var cellBackgroundColor: UIColor {
		switch self {
		case .night:
			return UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
		default:
			return .white
		}
	}
}

class BasicSlangTableViewCell: UITableViewCell, ThemeApplicable {
	func apply(_ theme: Theme) {
		textLabel?.textColor = theme.textColor
		backgroundColor = theme.cellBackgroundColor
	}
}
