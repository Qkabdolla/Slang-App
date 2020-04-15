//
//  DeleteWarningAlertable.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol DeleteWarningAlertable: class {
	func presentAlert(confirmHandler: @escaping () -> ())
}

extension DeleteWarningAlertable where Self: UIViewController {
	func presentAlert(confirmHandler: @escaping () -> ()) {
		let alertController = UIAlertController(title: "Warning", message: "Are you sure", preferredStyle: .alert)
		
		let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
			confirmHandler()
		})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		alertController.addAction(cancelAction)
		alertController.addAction(confirmAction)
		
		present(alertController, animated: true)
	}
}
