//
//  UITableView+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var separatorColor: UIColor? {
		switch self {
		case .night:
			return .gray
		case .day:
			return nil
		}
	}
	
	func getBackgroundColor(for style: UITableView.Style) -> UIColor {
		switch self {
		case .night:
			return .black
		case .day:
			switch style {
			case .plain:
				return .white
			case .grouped:
				return #colorLiteral(red: 0.9374348521, green: 0.9369043112, blue: 0.9586767554, alpha: 1)
			@unknown default:
				return .white
			}
		}
	}
}

extension UITableView: ThemeApplicable {
	func apply(_ theme: Theme) {
		backgroundColor = theme.getBackgroundColor(for: self.style)
		separatorColor = theme.separatorColor
	}
}
