//
//  SlangTableViewCell.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol SlangTableViewCellDelegate: class {
	func didTapOnBookmark(_ cell: SlangTableViewCell)
}

class SlangTableViewCell: BasicSlangTableViewCell {
	lazy var headerStackView = SlangDetailCellHeaderStackView()
	lazy var wordLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
		label.textColor = .black
		label.numberOfLines = 0
		return label
	}()
	lazy var thumbsStackView = ThumbsCellStackView()
	lazy var bookmarkButton: UIButton = {
		let button = UIButton()
		let image = UIImage(named: "bookmark")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(didTapBookmarkButton(_:)), for: .touchUpInside)
		return button
	}()
	
	weak var delegate: SlangTableViewCellDelegate?
	var theme: Theme!
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		layoutUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(cellModel: SlangCellModel) {
		headerStackView.set(author: cellModel.author, writtenOn: cellModel.writtenOn)
		wordLabel.text = cellModel.word
		thumbsStackView.setThumbs(up: cellModel.thumbsUp, down: cellModel.thumbsDown)
		bookmarkButton.tintColor = cellModel.isSaved ? theme.selectedBookmarkButtonTintColor : theme.unselectedBookmarkButtonTintColor
	}
	
	override func apply(_ theme: Theme) {
		self.theme = theme
		wordLabel.apply(theme)
		headerStackView.apply(theme)
		thumbsStackView.apply(theme)
		super.apply(theme)
	}
	
	private func layoutUI() {
		addSubview(headerStackView)
		headerStackView.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(16)
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-16)
		}
		
		addSubview(wordLabel)
		wordLabel.snp.makeConstraints { (make) in
			make.top.equalTo(headerStackView.snp.bottom).offset(8)
			make.leading.trailing.equalTo(headerStackView)
		}
		
		addSubview(thumbsStackView)
		thumbsStackView.snp.makeConstraints { (make) in
			make.top.equalTo(wordLabel.snp.bottom).offset(8)
			make.leading.equalTo(headerStackView)
			make.width.equalToSuperview().multipliedBy(0.4)
			make.bottom.equalToSuperview().offset(-16)
		}
		
		addSubview(bookmarkButton)
		bookmarkButton.snp.makeConstraints { (make) in
			make.trailing.equalTo(headerStackView)
			make.bottom.equalTo(thumbsStackView.snp.top)
			make.size.equalTo(24)
		}
	}
	
	@objc private func didTapBookmarkButton(_ sender: UIButton) {
		delegate?.didTapOnBookmark(self)
	}
}


private extension Theme {
	var selectedBookmarkButtonTintColor: UIColor {
		switch self {
		case .night: return .orange
		case .day: return .black
		}
	}
	
	var unselectedBookmarkButtonTintColor: UIColor {
		return .gray
	}
}
