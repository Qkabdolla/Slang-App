//
//  SavedSlangesViewController.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 7/27/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class SavedSlangesViewController: UIViewController, DeleteWarningAlertable {
	lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "Tap to search a saved slang"
		searchController.searchBar.apply(themeManager.currentTheme)
		return searchController
	}()
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SlangTableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	let viewModel = SavedSlangsViewModel()
	var themeManager: ThemeManager!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return themeManager.currentTheme.statusBarStyle
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Saved"
		
		subscribeToChanges()
		
		apply(themeManager.currentTheme)
		layoutUI()
		themeManager.subscribe(view)
		
		viewModel.delegate = self
		viewModel.fetchSavedSlangs()
	}
	
	private func layoutUI() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	private func subscribeToChanges() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(didChangeTheme(_:)),
											   name: .didChangeTheme,
											   object: nil)
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(updateTableView),
											   name: NSNotification.Name.NSManagedObjectContextDidSave,
											   object: nil)
	}
	
	func apply(_ theme: Theme) {
		navigationController?.navigationBar.apply(theme)
		tableView.apply(theme)
		searchController.searchBar.apply(theme)
		setNeedsStatusBarAppearanceUpdate()
		
		tableView.reloadData()
	}
	
	@objc private func updateTableView() {
		viewModel.fetchSavedSlangs()
	}
	
	@objc private func didChangeTheme(_ notification: Notification) {
		if let theme = notification.object as? Theme {
			apply(theme)
		}
	}
}

extension SavedSlangesViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfSlangs
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SlangTableViewCell else {
			return UITableViewCell()
		}
		
		let slangCellModel = viewModel.getSlangCellModel(at: indexPath.row)
		cell.apply(themeManager.currentTheme)
		cell.configure(cellModel: slangCellModel)
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let slang = viewModel.getSlang(at: indexPath.row)
		
		let slangDetailViewController = SlangDetailViewController(.slangFromSaved(slang))
		slangDetailViewController.themeManager = themeManager
		navigationController?.pushViewController(slangDetailViewController, animated: true)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension SavedSlangesViewController: SavedSlangsViewModelDelegate, SlangTableViewCellDelegate {
	func didTapOnBookmark(_ cell: SlangTableViewCell) {
		guard let cellRow = tableView.indexPath(for: cell)?.row else { return }
		presentAlert { [weak self] in
			self?.viewModel.deleteSlang(at: cellRow)
		}
	}
	
	func didFetchSlangs() {
		tableView.reloadData()
	}
}
