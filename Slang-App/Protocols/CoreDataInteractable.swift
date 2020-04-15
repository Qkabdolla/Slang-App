//
//  CoreDataInteractable.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataInteractable {
    var managedContext: NSManagedObjectContext { get }
}

extension CoreDataInteractable {
    var managedContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Failed to get AppDelegate")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
}
