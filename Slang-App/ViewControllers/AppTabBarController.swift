//
//  AppTabBarController.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 7/27/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
	private lazy var savedSlangsViewController: SavedSlangesViewController = {
		let viewController = SavedSlangesViewController()
		viewController.themeManager = themeManager
		viewController.tabBarItem = {
			let tabBarItem = UITabBarItem()
			tabBarItem.image = UIImage(named: "bookmark")
			tabBarItem.title = "Saved"
			return tabBarItem
		}()
		return viewController
	}()
	
	private lazy var searchSlangViewController: SearchSlangViewController = {
		let viewController = SearchSlangViewController()
		viewController.themeManager = themeManager
		viewController.tabBarItem = {
			let tabBarItem = UITabBarItem()
			tabBarItem.image = UIImage(named: "search")
			tabBarItem.title = "Search"
			return tabBarItem
		}()
		return viewController
	}()
	
	private lazy var settingsViewController: SettingsViewController = {
		var viewController = SettingsViewController()
		viewController.themeManager = themeManager
		viewController.tabBarItem = {
			let tabBarItem = UITabBarItem()
			tabBarItem.image = UIImage(named: "settings")
			tabBarItem.title = "Settings"
			return tabBarItem
		}()
		return viewController
	}()
	
	var themeManager: ThemeManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		themeManager = .init()
		
		subscribeToThemeChange()
		configureViewControllers()
		
		apply(themeManager.currentTheme)
	}
	
	private func configureViewControllers() {
		viewControllers = [savedSlangsViewController, searchSlangViewController, settingsViewController].map {
			UINavigationController(rootViewController: $0)
		}
	}
	
	private func subscribeToThemeChange() {
		NotificationCenter.default.addObserver(forName: .didChangeTheme, object: nil, queue: nil) { [weak self] (notification) in
			if let theme = notification.object as? Theme {
				self?.apply(theme)
			}
		}
	}
}
