//
//  ReportDAO.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 12/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation
import CoreData

class ReportDAO {
    //MARK:- Database Context
    let context = CDManager.shared.persistentContainer.viewContext
    
    //MARK:- Methods
    
    /// Description: Create an object of type Report on Core Data
    /// - Parameter report: entity related to the statistics of the Meals
    /// - Returns: Boolena refered if the report was created in database
    func create(report: Report, completion: (Bool) -> Void) {
        let reportCD = ReportCD(context: context)
        reportCD.uuid = report.uuid
        reportCD.week = Int32(report.week)
        reportCD.totalRightTime = Int32(report.totalRightTime)
        reportCD.totalWrongTime = Int32(report.totalWrongTime)
        reportCD.mostWrongTimeMeal = report.mostWrongTimeMeal
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Error do create a report")
            completion(false)
        }
    }
    
    func retrieve(completion: ([Report]?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReportCD")
        var reports: [Report] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            guard let reportsCD = fechedObjects as? [NSManagedObject] else {return }
            
            for report in reportsCD {
                
                reports.append(convertToReportEntity(reportCD: report))
            }
            
            completion(reports)
        }catch {
            print("Error do retrieve reports")
            completion(reports)
        }
    }
    
    func retrieveById(id: UUID, completion: (Report?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReportCD")
        
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            guard let reportsCD = fechedObjects as? [NSManagedObject] else {return }
            
            for report in reportsCD {
                if report.value(forKey: "uuid") as! UUID == id {
                    let reportEntity = convertToReportEntity(reportCD: report)
                    completion(reportEntity)
                }
            }
            
            print("Reports does not exists")
            completion(nil)
        }catch {
            print("Error do retrieve reports")
            completion(nil)
        }
    }
    
    func convertToReportEntity(reportCD: NSManagedObject) -> Report {
        let uuid = reportCD.value(forKey: "uuid") as! UUID
        let week = reportCD.value(forKey: "week") as! Int32
        let totalRightTime = reportCD.value(forKey: "totalRightTime") as! Int32
        let totalWrongTime = reportCD.value(forKey: "totalWrongTime") as! Int32
        let mostWrongTimeMeal = reportCD.value(forKey: "mostWrongTimeMeal") as! String
        
        let reportEntity = Report(uuid: uuid, week: Int(week), totalRightTime: Int(totalRightTime), totalWrongTime: Int(totalWrongTime), mostWrongTimeMeal: mostWrongTimeMeal)
        
        return reportEntity
    }
}
