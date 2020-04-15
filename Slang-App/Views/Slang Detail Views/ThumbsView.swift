//
//  ThumbsView.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

enum Thumb {
	case up
	case down
	
	var emoji: String {
		switch self {
		case .up: return "👍"
		case .down: return "👎"
		}
	}
}

class ThumbsStackView: UIStackView {
	init(thumbsUp: Int, thumbsDown: Int) {
		super.init(frame: .zero)
		
		axis = .horizontal
		distribution = .fillProportionally
		
		let thumbsUpLabel = getConfiguredLabel(numberOfthumbs: thumbsUp, thumb: .up)
		addArrangedSubview(thumbsUpLabel)
		
		let thumbsDownLabel = getConfiguredLabel(numberOfthumbs: thumbsDown, thumb: .down)
		addArrangedSubview(thumbsDownLabel)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func getConfiguredLabel(numberOfthumbs: Int, thumb: Thumb) -> UILabel {
		let label = UILabel()
		label.text = thumb.emoji + " " + numberOfthumbs.description
		label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		label.textAlignment = .center
		return label
	}
}
