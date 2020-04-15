//
//  ViewController.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 7/27/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

enum SettingsType: String {
	case nightMode = "Night Mode"
	case clearSlangs = "Clear slangs"
	case clearSearchHistory = "Clear search history"
}

class SettingsViewController: UIViewController {
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(BasicSlangTableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	let viewModel = SettingsViewModel()
	var themeManager: ThemeManager!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return themeManager.currentTheme.statusBarStyle
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Settings"
		
		apply(themeManager.currentTheme)
		subscribeToThemeChange()
		layoutUI()
		
		themeManager.subscribe(view)
	}
	
	private func layoutUI() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	private func subscribeToThemeChange() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(didChangeTheme(_:)),
											   name: .didChangeTheme,
											   object: nil)
	}
	
	func apply(_ theme: Theme) {
		tableView.apply(theme)
		navigationController?.navigationBar.apply(theme)
		setNeedsStatusBarAppearanceUpdate()
		
		tableView.reloadData()
	}
	
	@objc private func didChangeTheme(_ notification: Notification) {
		if let theme = notification.object as? Theme {
			apply(theme)
		}
	}
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let title: String = viewModel.titleForRowAt(section: indexPath.section,
													row: indexPath.row)
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchTableViewCell
			cell.textLabel?.text = title
			cell.switcher.setOn(themeManager.currentTheme == .night, animated: true)
			cell.delegate = self
			cell.apply(themeManager.currentTheme)
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasicSlangTableViewCell
			cell.textLabel?.text = title
			cell.apply(themeManager.currentTheme)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didTapRowAt(section: indexPath.section,
							  row: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension SettingsViewController: SwitchTableViewCellDelegate {
	func didChangeValue(_ value: Bool) {
		themeManager.currentTheme = value ? .night : .day
	}
}

