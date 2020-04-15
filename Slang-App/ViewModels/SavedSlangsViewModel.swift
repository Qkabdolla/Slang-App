//
//  SavedSlangsViewModel.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation
import CoreData

struct SlangCellModel {
	let word: String
	let author: String
	let writtenOn: String
	let thumbsUp: Int
	let thumbsDown: Int
	
	var isSaved: Bool
}

protocol SavedSlangsViewModelDelegate: class {
	func didFetchSlangs()
}

class SavedSlangsViewModel: CoreDataInteractable {
	var slangs: [DBSlang] = []
	
	let repository: SlangRepository
	
	weak var delegate: SavedSlangsViewModelDelegate?
	
	init() {
		self.repository = SlangRepository()
	}
	
	var numberOfSlangs: Int {
		return slangs.count
	}
	
	func getSlang(at index: Int) -> DBSlang {
		return slangs[index]
	}
	
	func getSlangCellModel(at index: Int) -> SlangCellModel {
		let slang = slangs[index]
		return SlangCellModel(word: slang.word ?? "",
							  author: slang.author ?? "",
							  writtenOn: Date.getPrettyDateString(fromDate: slang._writtenOn),
							  thumbsUp: slang._thumbsUp,
							  thumbsDown: slang._thumbsDown,
							  isSaved: true)
	}
	
	func fetchSavedSlangs() {
		self.slangs = repository.getSlangs()
		delegate?.didFetchSlangs()
	}
	
	func deleteSlang(at index: Int) {
		let slang = slangs[index]
		repository.deleteSlang(slang)
	}
}
