//
//  LinkView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol LinkViewDelegate: class {
	func didTapOnLink()
}

private extension Theme {
	var textColor: UIColor {
		switch self {
		case .night: return .orange
		case .day: return .systemBlue
		}
	}
}

class LinkView: UIView, ThemeApplicable {
	lazy var linkButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(didTapTitleButton(_:)), for: .touchUpInside)
		return button
	}()
	
	weak var delegate: LinkViewDelegate?
	private var theme: Theme = .day
	
	init(text: String) {
		super.init(frame: .zero)
		
		setText(text)
		layoutUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutUI() {
		addSubview(linkButton)
		linkButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(16)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-16)
		}
	}
	
	private func setText(_ text: String) {
		let underlineAttriString = self.underlineAttributedString(forText: text)
		linkButton.setAttributedTitle(underlineAttriString, for: .normal)
	}
	
	private func underlineAttributedString(forText text: String) -> NSAttributedString {
		return NSAttributedString(string: text,
								  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
											   NSAttributedString.Key.foregroundColor: theme.textColor])
	}
	
	@objc private func didTapTitleButton(_ sender: UIButton) {
		delegate?.didTapOnLink()
	}
	
	func apply(_ theme: Theme) {
		self.theme = theme
		setText("Link")
	}
}
