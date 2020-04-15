//
//  UIBarButtonItem+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var selectedBarButtonItemTintColor: UIColor {
		switch self {
		case .night: return .orange
		case .day: return .systemBlue
		}
	}
	
	var defaultBarButtonItemTintColor: UIColor {
		return .gray
	}
}

extension UIBarButtonItem {
	func set(selected: Bool, theme: Theme) {
		tintColor = selected ? theme.selectedBarButtonItemTintColor : theme.defaultBarButtonItemTintColor
	}
}
