//
//  SettingsViewModel.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

class SettingsViewModel {
	private let repository = SlangRepository()
	
	private let settings: [[SettingsType]] = [
		[SettingsType.nightMode],
		[SettingsType.clearSlangs,
		 SettingsType.clearSearchHistory]
	]
	
	var numberOfSections: Int {
		return settings.count
	}
	
	func numberOfRows(in section: Int) -> Int {
		return settings[section].count
	}
	
	func titleForRowAt(section: Int, row: Int) -> String {
		return settings[section][row].rawValue
	}
	
	func didTapRowAt(section: Int, row: Int) {
		let setting = settings[section][row]
		switch setting {
		case .clearSlangs:
			deleteAllSlangs()
		case .clearSearchHistory:
			clearSearchHistory()
		default:
			break
		}
	}
	
	func switchToNightMode(enable: Bool) {
		
	}
	
	private func deleteAllSlangs() {
		repository.deleteAllSlangs()
	}
	
	private func clearSearchHistory() {
		SearchHistoryStorage.shared.clearSearchHistory()
	}
}
