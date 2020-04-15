//
//  Notification+Extension.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

extension Notification.Name {
	static let didChangeTheme: Notification.Name = {
		return .init("themeDidChange")
	}()
}
