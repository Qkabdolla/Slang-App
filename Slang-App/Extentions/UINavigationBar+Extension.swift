//
//  UINavigationBar+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var titleTextAttributes: [NSAttributedString.Key: UIColor] {
		switch self {
		case .night:
			return [NSAttributedString.Key.foregroundColor: UIColor.white]
		case .day:
			return [NSAttributedString.Key.foregroundColor: UIColor.black]
		}
	}
	
	var barStyle: UIBarStyle {
		switch self {
		case .night: return .black
		case .day: return .default
		}
	}
	
	var tintColor: UIColor {
		switch self {
		case .night: return .orange
		case .day: return .systemBlue
		}
	}
}

extension UINavigationBar: ThemeApplicable {
	func apply(_ theme: Theme) {
		titleTextAttributes = theme.titleTextAttributes
		barStyle = theme.barStyle
		tintColor = theme.tintColor
	}
}
