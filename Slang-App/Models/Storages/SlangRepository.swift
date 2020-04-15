//
//  SlangRepository.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation
import CoreData

class SlangRepository: CoreDataInteractable {
    
    func getSlangs() -> [DBSlang] {
        let fetchRequest = DBSlang.fetchSlangesRequest()
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func isSavedSlang(withId defid: Int) -> Bool {
        let fetchRequest = DBSlang.fetchSlangesRequest()
        
        fetchRequest.predicate = NSPredicate(format: "defid == %i", defid)
        
        do {
            let fetchResultCount = try managedContext.count(for: fetchRequest)
            return fetchResultCount != 0
        } catch {
            return false
        }
    }
    
    @discardableResult
    func saveSlang(_ slang: Slang) -> Bool {
        let dbSlang = DBSlang(context: managedContext)
        dbSlang.defid = Int64(slang.defid)
        dbSlang.author = slang.author
        dbSlang.word = slang.word
        dbSlang.definition = slang.definition
        dbSlang.example = slang.example
        dbSlang.permalink = slang.permalink
        dbSlang.thumbsUp = Int64(slang.thumbsUp)
        dbSlang.thumbsDown = Int64(slang.thumbsDown)
        dbSlang.writtenOn = slang._writtenOn as NSDate as Date
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteSlang(withId id: String) -> Bool {
        let fetchRequest = DBSlang.fetchSlangesRequest()
        fetchRequest.predicate = NSPredicate(format: "defid == %@", id)
        
        do {
            let resultSlangs = try managedContext.fetch(fetchRequest)
            guard let slang = resultSlangs.first else { return false }
            
            managedContext.delete(slang)
            try managedContext.save()
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteSlang(_ slang: DBSlang) -> Bool {
        managedContext.delete(slang)
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteAllSlangs() -> Bool {
        let slangs = getSlangs()
        for slang in slangs {
            managedContext.delete(slang)
        }
        
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
