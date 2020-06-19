//
//  AppUtilsDAO.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 18/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation
import CoreData

class AppUtilsDAO {
    static let shared = AppUtilsDAO()
    private init () {}
    
    
    //MARK:- Database Context
    let context = CDManager.shared.persistentContainer.viewContext
    
    //MARK:- Methods
    
    /// Description: Create the app Utils entity with the firsdt time in the app
    /// - Parameter completion: when the method ends
    func createAppUtils(completion: () -> Void) {
        let appUtils =  AppUtilsCD(context: context)
        appUtils.firstTimeInTheApp = Date()
        
        do {
            try context.save()
        } catch {
            print("Error")
        }
    }
    
    
    /// Description: Save the utils data of the App
    /// - Parameters:
    ///   - applicationSuspendedTime: an optional that tells when the app is suspended
    ///   - expectedTimeDelay: an ooptional that tells the time dalay to crate a notification
    ///   - completion: return if the method succed
    func saveAppUtils(applicationSuspendedTime: Date? = nil, expectedTimeDelay: Date? = nil, completion: (Bool) -> Void) {
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUtilsCD")
        
        do {
            let fetchObjects = try context.fetch(featchRequest)
            
            let appUtilsCD = fetchObjects[0] as! NSManagedObject
            
            appUtilsCD.setValue(applicationSuspendedTime, forKey: "applicationSuspendedTime")
            
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        } catch {
            completion(false)
        }
    }
    
    
    /// Description: get the AppUtils
    /// - Parameter completion: return the AppUtils
    func retrieve(completion: (AppUtils?) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUtilsCD")
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            guard let appUtilsCD = fetchedObjects[0] as? NSManagedObject else { return }
            
            let appUtils = AppUtils(firstTimeInTheApp: appUtilsCD.value(forKey: "firstTimeInTheApp") as! Date, expectedTimeDelay: appUtilsCD.value(forKey: "expectedTimeDelay") as? Date, applicationSuspendedTime: appUtilsCD.value(forKey: "applicationSuspendedTime") as? Date)
            
            completion(appUtils)
        } catch {
            print("Error retrieving meals")
            completion(nil)
        }
    }
}
