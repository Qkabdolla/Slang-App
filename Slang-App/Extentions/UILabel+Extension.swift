//
//  UILabel+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

private extension Theme {
	var textColor: UIColor {
		switch self {
		case .night:
			return .white
		case .day:
			return .black
		}
	}
}

extension UILabel: ThemeApplicable {
	func apply(_ theme: Theme) {
		textColor = theme.textColor
	}
}
