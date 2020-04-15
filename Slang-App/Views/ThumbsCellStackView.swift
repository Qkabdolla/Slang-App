//
//  ThumbsCellStackView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

class ThumbsCellStackView: UIStackView, ThemeApplicable {
	lazy var thumbsUpLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
		return label
	}()
	
	lazy var thumbsDownLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		axis = .horizontal
		distribution = .fillEqually
		
		addArrangedSubview(thumbsUpLabel)
		addArrangedSubview(thumbsDownLabel)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setThumbs(up: Int, down: Int) {
		thumbsUpLabel.text = Thumb.up.emoji + " " + up.description
		thumbsDownLabel.text = Thumb.down.emoji + " " + down.description
	}
	
	func apply(_ theme: Theme) {
		thumbsUpLabel.apply(theme)
		thumbsDownLabel.apply(theme)
	}
}
