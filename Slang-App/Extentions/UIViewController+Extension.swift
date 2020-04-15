//
//  UIViewController+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

extension UIViewController {
	func isCurrentVCIsDisplaying() -> Bool {
		if let displayingVC = navigationController?.viewControllers.last, let selectedIndex = tabBarController?.selectedIndex {
			return displayingVC === self && selectedIndex == 1
		}
		
		return false
	}
}
