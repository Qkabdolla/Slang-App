//
//  KeyboardAppearanceObservable.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol KeyboardAppearanceObservable: class {
	func keyboardWillShow(_ height: CGFloat)
	func keyboardWillHide()
	func registerForKeyboardEvents()
	func unregisterFromKeyboardEvents()
}

extension KeyboardAppearanceObservable where Self: UIViewController {
	func registerForKeyboardEvents() {
		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
			guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
			
			self?.keyboardWillShow(keyboardHeight)
		}
		
		_ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] _ in
			self?.keyboardWillHide()
		}
	}
	
	func unregisterFromKeyboardEvents() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}
