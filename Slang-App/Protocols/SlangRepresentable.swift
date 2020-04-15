//
//  SlangRepresentable.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

protocol SlangRepresentable {
	var author: String { get set }
	var word: String { get set }
	var definition: String { get set }
	var example: String { get set }
	var permalink: String { get set }
	var _thumbsUp: Int { get }
	var _thumbsDown: Int { get }
	var _writtenOn: Date { get }
}
