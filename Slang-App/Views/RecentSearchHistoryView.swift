//
//  RecentSearchHistoryView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol RecentSearchHistoryViewDelegate: class {
	func didTapOnRecentSearch(_ recentSearch: String)
}

class RecentSearchHistoryView: UIView, ThemeApplicable {
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.isScrollEnabled = true
		tableView.tableFooterView = UIView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(BasicSlangTableViewCell.self, forCellReuseIdentifier: "cell")
		return tableView
	}()
	weak var delegate: RecentSearchHistoryViewDelegate?
	var recentSearches: [String] = []
	var theme: Theme!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		SearchHistoryStorage.shared.onChange { [weak self] () -> Bool in
			guard let `self` = self else {
				return false
			}
			
			self.getRecentSearchHistory()
			return true
		}
		
		getRecentSearchHistory()
		setupTableView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupTableView() {
		addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: topAnchor),
			tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func apply(_ theme: Theme) {
		self.theme = theme
		tableView.apply(theme)
		tableView.reloadData()
	}
	
	private func getRecentSearchHistory() {
		recentSearches = SearchHistoryStorage.shared.getRecentSearches()
		tableView.reloadData()
	}
	
	func setHidden(_ enabled: Bool) {
		guard isHidden != enabled else { return }
		
		if enabled {
			UIView.animate(withDuration: 0.3, animations: {
				self.alpha = 0
			}, completion: { (_) in
				self.isHidden = true
			})
		} else {
			self.isHidden = false
			UIView.animate(withDuration: 0.3) {
				self.alpha = 1
			}
		}
	}
}

extension RecentSearchHistoryView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recentSearches.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return recentSearches.isEmpty ? nil : "Search History"
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasicSlangTableViewCell
		cell.textLabel?.text = recentSearches[indexPath.row]
		cell.apply(theme)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didTapOnRecentSearch(recentSearches[indexPath.row])
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
