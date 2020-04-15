//
//  SlangDetailViewController.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 7/27/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

enum SlangDetailType {
	case slangFromSearch(Slang)
	case slangFromSaved(DBSlang)
	
	var slang: SlangRepresentable {
		switch self {
		case .slangFromSaved(let savedSlang):
			return savedSlang
		case .slangFromSearch(let slang):
			return slang
		}
	}
}

class SlangDetailViewController: UIViewController, DeleteWarningAlertable {
	let viewModel: SlangDetalViewModel
	
	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	lazy var contentView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 15
		return view
	}()
	
	lazy var barButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark"),
											 style: .plain,
											 target: self,
											 action: #selector(didTapRightBarButtonItem(_:)))
	
	var themeManager: ThemeManager!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return themeManager.currentTheme.statusBarStyle
	}
	
	init(_ slang: SlangDetailType) {
		viewModel = SlangDetalViewModel(slangType: slang)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = viewModel.slang.word
		
		subscribeToChanges()
		setupBarButtonItem()
		layoutUI()
		
		apply(themeManager.currentTheme)
		
		themeManager.subscribe(view)
	}
	
	private func layoutUI() {
		view.addSubview(scrollView)
		scrollView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
		
		scrollView.addSubview(contentView)
		view.sendSubviewToBack(scrollView)
		contentView.snp.makeConstraints { (make) in
			make.edges.equalTo(scrollView)
			make.width.equalTo(scrollView)
		}
		
		let author = viewModel.slang.author
		let writtenOn = Date.getPrettyDateString(fromDate: viewModel.slang._writtenOn)
		
		let headerDetailView = SlangDetailHeaderView(author: author, writtenOn: writtenOn)
		contentView.addSubview(headerDetailView)
		headerDetailView.snp.makeConstraints { (make) in
			make.top.leading.trailing.equalToSuperview()
		}
		
		let word = viewModel.slang.word
		let wordView = DynamicLabelView(text: word,
										textColor: .black,
										font: UIFont.systemFont(ofSize: 18, weight: .bold))
		contentView.addSubview(wordView)
		wordView.snp.makeConstraints { (make) in
			make.top.equalTo(headerDetailView.snp.bottom)
			make.leading.trailing.equalToSuperview()
		}
		
		let definition = viewModel.slang.definition
		let definitionView = DynamicLabelView(text: definition,
											  textColor: .black,
											  font: UIFont.systemFont(ofSize: 16, weight: .regular))
		contentView.addSubview(definitionView)
		definitionView.snp.makeConstraints { (make) in
			make.top.equalTo(wordView.snp.bottom)
			make.leading.trailing.equalToSuperview()
		}
		
		let example = viewModel.slang.example
		let exampleView = DynamicLabelView(text: example,
										   textColor: .black,
										   font: UIFont.systemFont(ofSize: 14, weight: .light))
		contentView.addSubview(exampleView)
		exampleView.snp.makeConstraints { (make) in
			make.top.equalTo(definitionView.snp.bottom)
			make.leading.trailing.equalToSuperview()
		}
		
		let linkView = LinkView(text: "Link")
		linkView.delegate = self
		contentView.addSubview(linkView)
		linkView.snp.makeConstraints { (make) in
			make.top.equalTo(exampleView.snp.bottom)
			make.leading.trailing.equalToSuperview()
		}
		
		let thumbsUp: Int = viewModel.slang._thumbsUp
		let thumbsDown: Int = viewModel.slang._thumbsDown
		let thumbsStackView = ThumbsStackView(thumbsUp: thumbsUp, thumbsDown: thumbsDown)
		contentView.addSubview(thumbsStackView)
		thumbsStackView.snp.makeConstraints { (make) in
			make.top.equalTo(linkView.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(-16)
		}
	}
	
	private func setupBarButtonItem() {
		navigationItem.rightBarButtonItem = barButtonItem
	}
	
	private func subscribeToChanges() {
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
		scrollView.backgroundColor = theme.backgroundColor
		navigationController?.navigationBar.apply(theme)
		barButtonItem.set(selected: viewModel.isSlangSaved(), theme: themeManager.currentTheme)
		setNeedsStatusBarAppearanceUpdate()
	}
	
	@objc private func didTapRightBarButtonItem(_ sender: UIBarButtonItem) {
		let theme = themeManager.currentTheme
		if viewModel.isSlangSaved() {
			presentAlert { [unowned self] in
				let isSucceeded = self.viewModel.deleteSlang()
				if isSucceeded {
					self.barButtonItem.set(selected: false, theme: theme)
				}
			}
			
		} else {
			let isSucceeded = viewModel.saveSlang()
			if isSucceeded {
				barButtonItem.set(selected: true, theme: theme)
			}
		}
	}
	
	@objc private func updateData() {
		if !isCurrentVCIsDisplaying() {
			barButtonItem.set(selected: viewModel.isSlangSaved(), theme: themeManager.currentTheme)
		}
	}
	
	@objc private func didChangeTheme(_ notification: Notification) {
		if let theme = notification.object as? Theme {
			apply(theme)
		}
	}
}

extension SlangDetailViewController: LinkViewDelegate {
	func didTapOnLink() {
		// TODO: Go to safari
	}
}
