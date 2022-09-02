//
//  CoreDataManager.swift
//  Vision + CoreML
//
//  Created by 김혜수 on 2022/09/01.
//  Copyright © 2022 Apple. All rights reserved.
//  https://ios-development.tistory.com/93?category=894544

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    //read the data
    func fetch() -> [NSManagedObject] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dog")
        
        //sort
        let sort = NSSortDescriptor(key: "photoDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    //save
    func save(dogPhoto: Data, photoDate: Date, dogBreedInfo: String) -> Bool {
        let context = persistentContainer.viewContext
        
        let dog = NSEntityDescription.insertNewObject(forEntityName: "Dog", into: context)
        dog.setValue(dogPhoto, forKey: "dogPhoto")
        dog.setValue(photoDate, forKey: "photoDate")
        dog.setValue(dogBreedInfo, forKey: "dogBreedInfo")
        
        do{
            try context.save()
            //self.list.insert(dog, at: 0)
            self.list.append(dog)
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}
