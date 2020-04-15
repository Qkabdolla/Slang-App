//
//  DynamicLabelView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

class DynamicLabelView: UIView {
	lazy var textLabel = UILabel()
	
	init(text: String, textColor: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)) {
		super.init(frame: .zero)
		
		textLabel.text = text
		textLabel.textColor = textColor
		textLabel.font = font
		textLabel.numberOfLines = 0
		
		layoutUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutUI() {
		addSubview(textLabel)
		textLabel.snp.makeConstraints { (make) in
			make.top.leading.equalToSuperview().offset(16)
			make.trailing.bottom.equalToSuperview().offset(-16)
		}
	}
}
