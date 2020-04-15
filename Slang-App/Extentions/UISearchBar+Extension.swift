//
//  UISearchBar+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var keyboardAppearance: UIKeyboardAppearance {
		switch self {
		case .night: return .dark
		case .day: return .default
		}
	}
	
	var cancelBarButtonItemAttributes: [NSAttributedString.Key: Any] {
		var color: UIColor = .systemBlue
		switch self {
		case .night:
			color = .orange
		case .day:
			 break
		}
		
		return [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
	}
}

extension UISearchBar: ThemeApplicable {
	func apply(_ theme: Theme) {
		keyboardAppearance = theme.keyboardAppearance
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(theme.cancelBarButtonItemAttributes, for: .normal)
	}
}

