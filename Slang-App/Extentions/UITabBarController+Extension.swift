//
//  UITabBarController+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var barBackgroundColor: UIColor {
		switch self {
		case .night:
			return .black
		case .day:
			return .white
		}
		
	}
	
	var barForegroundColor: UIColor {
		switch self {
		case .night:
			return .orange
		case .day:
			return .systemBlue
		}
	}
}

extension UITabBarController: ThemeApplicable {
	func apply(_ theme: Theme) {
		view.backgroundColor = theme.backgroundColor
		
		tabBar.barTintColor = theme.barBackgroundColor
		tabBar.tintColor = theme.barForegroundColor
	}
}

