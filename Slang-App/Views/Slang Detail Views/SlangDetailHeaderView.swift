//
//  SlangDetailHeaderView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

class SlangDetailHeaderView: UIView {
	private lazy var authorLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	
	private lazy var writtenOnLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.textAlignment = .right
		return label
	}()
	
	init(author: String, writtenOn: String) {
		super.init(frame: .zero)
		
		authorLabel.text = author
		writtenOnLabel.text = writtenOn
		
		layoutUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutUI() {
		addSubview(authorLabel)
		authorLabel.snp.makeConstraints { (make) in
			make.top.leading.equalToSuperview().offset(16)
			make.bottom.equalToSuperview().offset(-16)
			make.width.equalToSuperview().multipliedBy(0.5)
		}
		
		addSubview(writtenOnLabel)
		writtenOnLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(authorLabel)
			make.trailing.equalToSuperview().offset(-16)
			make.leading.equalTo(authorLabel.snp.trailing)
		}
	}
}
