//
//  SwitchTableViewCell.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
	func didChangeValue(_ value: Bool)
}

class SwitchTableViewCell: BasicSlangTableViewCell {
	lazy var switcher: UISwitch = {
		let switcher = UISwitch()
		switcher.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
		return switcher
	}()
	
	weak var delegate: SwitchTableViewCellDelegate?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = .none
		
		layoutUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutUI() {
		addSubview(switcher)
		switcher.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().inset(16)
		}
	}

	override func apply(_ theme: Theme) {
		switcher.onTintColor = theme.switchOnTintColor
		super.apply(theme)
	}
	
	@objc private func didChangeValue(_ sender: UISwitch) {
		delegate?.didChangeValue(sender.isOn)
	}
}

private extension Theme {
	var switchOnTintColor: UIColor? {
		switch self {
		case .night: return .orange
		case .day: return nil
		}
	}
}
