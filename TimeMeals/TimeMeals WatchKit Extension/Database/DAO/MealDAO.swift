//
//  MealDAO.swift
//  TimeMeals WatchKit Extension
//
//  Created by Joao Paulo Pereira dos Santos on 13/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation
import CoreData

class MealDAO {
    static let shared = MealDAO()
    private init () {}
    
    //MARK:- Database Context
    let context = CDManager.shared.persistentContainer.viewContext
    
    //MARK:- Methods
    
    /// Description: Create an object of type Meal on Core Data
    /// - Parameter meal: model class of Meal
    /// - completion: returns a boolean refered if the meal was created in database
    func create(meal: Meal, completion: (Bool) -> Void) {
        let mealCD = MealCD(context: context)
        mealCD.uuid = meal.uuid
        mealCD.title = meal.title
        mealCD.time = meal.time
        mealCD.status = meal.status.rawValue.data(using: .utf8)
        mealCD.wrongTimes = Int32(meal.wrongTimes)
        
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Error creating a meal")
            completion(false)
        }
    }
    
    /// Description: Retrieve all Meal entities from Core Data
    /// - Parameter completion: return the Meals or return nil
    func retrieve(completion: ([Meal]?) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MealCD")
        var meals: [Meal] = []
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            guard let mealsCD = fetchedObjects as? [NSManagedObject] else { return }
            for meal in mealsCD {
                meals.append(convertToMealEntity(mealCD: meal))
            }
            
            completion(meals)
        } catch {
            print("Error retrieving meals")
            completion(nil)
        }
    }
    
    /// Description: Return a unique Meal by id
    /// - Parameters:
    ///     - id: the id to search
    ///     - completion: the meal searched if found
    func retrieveById(id: UUID, completion: (Meal?) -> Void ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MealCD")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            guard let mealsCD = fetchedObjects as? [NSManagedObject] else { return }
            
            for meal in mealsCD {
                if meal.value(forKey: "uuid") as! UUID == id {
                    let mealEntity = convertToMealEntity(mealCD: meal)
                    completion(mealEntity)
                    
                }
            }
            print("Non-existent meal")
            completion(nil)
            
        } catch {
            print("Error retrieving meals")
            completion(nil)
        }
    }
    
    
    /// Description: update an object of type Meal on Core Data
    /// - Parameter meal: model class of Meal
    /// - completion: returns a boolean refered if the meal was updated in database
    func update(meal: Meal,  completion: (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MealCD")
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", meal.uuid as CVarArg)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            
            guard let mealUpdate = fetchedObjects.first as? NSManagedObject else { return }
            mealUpdate.setValue(meal.title, forKey: "title")
            mealUpdate.setValue(meal.time, forKey: "time")
            mealUpdate.setValue(meal.status.rawValue.data(using: .utf8), forKey: "status")
            mealUpdate.setValue(meal.wrongTimes, forKey: "wrongTimes")
            
            do {
                try context.save()
                completion(true)
            } catch {
                print("Error updating meal")
                completion(false)
            }
        } catch {
            print("Error updating meal")
            completion(false)
        }
    }
    
    /// Description: update an object of type Meal on Core Data
    /// - Parameter meal: model class of Meal
    /// - completion: returns a boolean refered if the meal was deleted in database
    func delete(meal: Meal,  completion: (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MealCD")
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", meal.uuid as CVarArg)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            
            guard let mealDelete = fetchedObjects[0] as? NSManagedObject else { return }
            
            do {
                context.delete(mealDelete)
                try context.save()
                completion(true)
            } catch {
                print("Error updating meal")
                completion(false)
            }
        } catch {
            print("Error fetching meal")
            completion(false)
        }
    }
    
    /// Description: convert Meal Core Data type to a Meal model type
    /// - Parameter mealCD: Core Data meal
    /// - Returns: Meal type model
    func convertToMealEntity(mealCD: NSManagedObject) -> Meal {
        
        let uuid = mealCD.value(forKey: "uuid") as! UUID
        let title = mealCD.value(forKey: "title") as! String
        let time = mealCD.value(forKey: "time") as! Date
        let statusData = mealCD.value(forKey: "status") as! Data
        let status = String(data: statusData, encoding: .utf8)!
        let wrongTimes = mealCD.value(forKey: "wrongTimes") as! Int32
        
        let mealEntity = Meal(uuid: uuid, title: title, time: time, status: MealStatus(rawValue: status)!, wrongTimes: Int(wrongTimes))
        
        return mealEntity
    }
}

