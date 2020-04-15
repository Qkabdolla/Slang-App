//
//  SearchSlangViewController.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 7/27/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

enum SearchTableViewState {
	case active
	case fetching
	case fetched
	case emptyResult
	case none
}

class SearchSlangViewController: UIViewController, CanDisplayLoader, DeleteWarningAlertable {
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(SlangTableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.tableFooterView = UIView()
		return tableView
	}()
	lazy var recentSearchHistoryView: RecentSearchHistoryView = {
		let view = RecentSearchHistoryView()
		view.delegate = self
		return view
	}()
	let viewModel = SearchSlangViewModel()
	
	var searchState: SearchTableViewState = .none {
		didSet {
			switch searchState {
			case .active, .none:
				recentSearchHistoryView.setHidden(false)
				tableView.isHidden = true
			case .fetching:
				showLoader()
				recentSearchHistoryView.setHidden(true)
				tableView.isHidden = false
			case .emptyResult:
				hideLoader()
				recentSearchHistoryView.setHidden(true)
				tableView.isHidden = false
			case .fetched:
				hideLoader()
				recentSearchHistoryView.setHidden(true)
				tableView.isHidden = false
			}
		}
	}
	
	lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "Tap to search a slang"
		searchController.searchBar.delegate = self
		searchController.delegate = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.apply(themeManager.currentTheme)
		return searchController
	}()
	
	var themeManager: ThemeManager!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return themeManager.currentTheme.statusBarStyle
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationItem.hidesSearchBarWhenScrolling = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Search"
		
		viewModel.delegate = self
		recentSearchHistoryView.delegate = self
		
		apply(themeManager.currentTheme)
		subscribeToChanges()
		layoutUI()
		
		themeManager.subscribe(view)
	}
	
	private func layoutUI() {
		setupNavigationBar()
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
		
		view.addSubview(recentSearchHistoryView)
		recentSearchHistoryView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	private func setupNavigationBar() {
		navigationItem.searchController = searchController
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func subscribeToChanges() {
		registerForKeyboardEvents()
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(didChangeTheme(_:)),
											   name: .didChangeTheme,
											   object: nil)
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(updateData),
											   name: .NSManagedObjectContextDidSave,
											   object: nil)
	}
	
	func apply(_ theme: Theme) {
		tableView.apply(theme)
		navigationController?.navigationBar.apply(theme)
		searchController.searchBar.apply(theme)
		setNeedsStatusBarAppearanceUpdate()
		
		tableView.reloadData()
	}
	
	@objc private func updateData() {
		viewModel.updateSavedSlangIndices()
		
		if !isCurrentVCIsDisplaying() {
			tableView.reloadData()
		}
	}
	
	@objc private func didChangeTheme(_ notification: Notification) {
		if let theme = notification.object as? Theme {
			apply(theme)
		}
	}
}

extension SearchSlangViewController: UISearchControllerDelegate, UISearchBarDelegate {
	func didPresentSearchController(_ searchController: UISearchController) {
		searchState = .active
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		guard searchState != .fetching else { return }
		
		if searchController.searchBar.text == "" {
			searchState = .none
		} else {
			let hasResult: Bool = viewModel.numberOfSlangs > 0
			searchState = hasResult ? .fetched : .emptyResult
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchState = .active
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else { return }
		searchState = .fetching
		viewModel.search(query: text)
		SearchHistoryStorage.shared.storeSearch(text)
		
		searchBar.text = nil
		searchController.dismiss(animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = nil
		searchState = .none
	}
}

extension SearchSlangViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfSlangs
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SlangTableViewCell else {
			return UITableViewCell()
		}
		
		let slangCellModel = viewModel.getSlangCellModel(at: indexPath.row)
		cell.delegate = self
		cell.apply(themeManager.currentTheme)
		cell.configure(cellModel: slangCellModel)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let slang = viewModel.getSlang(at: indexPath.row)
		
		let slangDetailViewController = SlangDetailViewController(.slangFromSearch(slang))
		slangDetailViewController.themeManager = themeManager
		navigationController?.pushViewController(slangDetailViewController, animated: true)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension SearchSlangViewController: SearchSlangViewModelDelegate {
	func reloadTableView() {
		let hasResult: Bool = viewModel.numberOfSlangs > 0
		searchState = hasResult ? .fetched : .emptyResult
		tableView.reloadData()
	}
	
	func reloadRow(_ row: Int) {
		tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
	}
	
	func didFailFetching(withReason reason: String) {
		searchState = .emptyResult
		
		let alertController = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default)
		alertController.addAction(okAction)
		
		present(alertController, animated: true)
	}
}

extension SearchSlangViewController: RecentSearchHistoryViewDelegate, SlangTableViewCellDelegate {
	func didTapOnBookmark(_ cell: SlangTableViewCell) {
		guard let index = tableView.indexPath(for: cell)?.row else {
			return
		}
		
		if viewModel.isAlreadySavedSlang(at: index) {
			presentAlert { [weak self] in
				self?.viewModel.deleteSlang(at: index)
			}
		} else {
			viewModel.saveSlang(at: index)
		}
	}
	
	func didTapOnRecentSearch(_ recentSearch: String) {
		searchState = .fetching
		viewModel.search(query: recentSearch)
		
		searchController.searchBar.text = nil
		searchController.dismiss(animated: true)
	}
}

extension SearchSlangViewController: KeyboardAppearanceObservable {
	func keyboardWillShow(_ height: CGFloat) {
		recentSearchHistoryView.snp.updateConstraints { (update) in
			update.bottom.equalTo(view.safeAreaLayoutGuide).offset(-height + view.safeAreaInsets.bottom)
		}
		
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
	func keyboardWillHide() {
		recentSearchHistoryView.snp.updateConstraints { (update) in
			update.bottom.equalTo(view.safeAreaLayoutGuide)
		}
		
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
}
