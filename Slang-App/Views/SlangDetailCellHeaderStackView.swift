//
//  SlangDetailCellHeaderStackView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

class SlangDetailCellHeaderStackView: UIStackView, ThemeApplicable {
	lazy var authorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.textColor = .lightGray
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		return label
	}()
	
	lazy var writtenOnLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = .lightGray
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		axis = .horizontal
		distribution = .fillEqually
		
		addArrangedSubview(authorLabel)
		addArrangedSubview(writtenOnLabel)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(author: String, writtenOn: String) {
		authorLabel.text = author
		writtenOnLabel.text = writtenOn
	}
	
	func apply(_ theme: Theme) {
		authorLabel.apply(theme)
		writtenOnLabel.apply(theme)
	}
}
