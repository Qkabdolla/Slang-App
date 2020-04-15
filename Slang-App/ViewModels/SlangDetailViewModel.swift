//
//  SlangDetailViewModel.swift
//  Midterm-Project_OneLab
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation
import CoreData

class SlangDetalViewModel: CoreDataInteractable {
	private let slangType: SlangDetailType
	private let repository: SlangRepository
	
	let slang: SlangRepresentable
	
	init(slangType: SlangDetailType) {
		self.slangType = slangType
		slang = slangType.slang
		repository = SlangRepository()
	}
	
	func isSlangSaved() -> Bool {
		switch slangType {
		case .slangFromSearch(let slang):
			return repository.isSavedSlang(withId: slang.defid)
		case .slangFromSaved(let savedSlang):
			return repository.isSavedSlang(withId: Int(savedSlang.defid))
		}
	}
	
	func saveSlang() -> Bool {
		switch slangType {
		case .slangFromSearch(let slang):
			return repository.saveSlang(slang)
		case .slangFromSaved:
			fatalError("Unabled to save already saved slang")
		}
	}
	
	func deleteSlang() -> Bool {
		switch slangType {
		case .slangFromSearch(let slang):
			return repository.deleteSlang(withId: slang.defid.description)
		case .slangFromSaved(let savedSlang):
			return repository.deleteSlang(savedSlang)
		}
	}
}
