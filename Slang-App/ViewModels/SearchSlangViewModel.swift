//
//  SearchSlangViewModel.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

protocol SearchSlangViewModelDelegate: class {
	func reloadTableView()
	func reloadRow(_ row: Int)
	func didFailFetching(withReason reason: String)
}

class SearchSlangViewModel {
	let networkManager = NetworkManager()
	let repository = SlangRepository()
	
	private var slangs: [Slang] = []
	private var savedSlangsIndices: [Int] = []
	
	weak var delegate: SearchSlangViewModelDelegate?
	
	var numberOfSlangs: Int {
		return slangs.count
	}
	
	init() {
		savedSlangsIndices = repository.getSlangs().map { Int($0.defid) }
	}
	
	func search(query: String) {
		networkManager.getSlanges(query: query, success: { [weak self] (slangs) in
			self?.slangs = slangs
			self?.delegate?.reloadTableView()
		}, failure: { (reason) in
			self.delegate?.didFailFetching(withReason: reason)
		})
	}
	
	func deleteSlang(at index: Int) {
		let slangId = slangs[index].defid
		let isSucceeded = repository.deleteSlang(withId: slangId.description)
		
		if isSucceeded {
			savedSlangsIndices = repository.getSlangs().map { Int($0.defid) }
			delegate?.reloadRow(index)
		}
	}
	
	func saveSlang(at index: Int) {
		let slang = slangs[index]
		let isSucceeded = repository.saveSlang(slang)
		
		if isSucceeded {
			savedSlangsIndices = repository.getSlangs().map { Int($0.defid) }
			delegate?.reloadRow(index)
		}
	}
	
	func updateSavedSlangIndices() {
		savedSlangsIndices = repository.getSlangs().map { Int($0.defid) }
	}
	
	func isAlreadySavedSlang(at index: Int) -> Bool {
		let slangId = slangs[index].defid
		return savedSlangsIndices.contains(slangId)
	}
	
	func getSlangCellModel(at index: Int) -> SlangCellModel {
		let slang = slangs[index]
		return SlangCellModel(word: slang.word,
							  author: slang.author,
							  writtenOn: Date.getPrettyDateString(fromString: slang.writtenOn),
							  thumbsUp: Int(slang.thumbsUp),
							  thumbsDown: Int(slang.thumbsDown),
							  isSaved: savedSlangsIndices.contains(slang.defid))
	}
	
	func getSlang(at index: Int) -> Slang {
		return slangs[index]
	}
}
