//
//  ExtensionDelegate.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if  verifyFirstLaunch(){
            self.createDefaultMeal()
            self.createFirstReport()
            AppNotification().requestAuthorization()
        }
        
        scheduleNewMealStatus()
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                resetMeals()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    /// Description: creates and initializes the standard diet for the user to follow
    func createDefaultMeal(){
        let date = DateManager()
        let defaultMeals = [Meal(uuid: UUID.init(), title: "Desjejum", time: date.setUpDate(hour: 7, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Café da Manhã", time: date.setUpDate(hour: 11, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Almoço", time: date.setUpDate(hour: 13, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Lanche da Tarde", time: date.setUpDate(hour: 17, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Jantar", time: date.setUpDate(hour: 20, minute: 0), status: .notTimeYet, wrongTimes: 0)
                            ]
        defaultMeals.forEach { (meal) in
            MealDAO.shared.create(meal: meal) { _ in
                return
            }
        }
    }
    
    /// Description:  create the first report of the app
    func createFirstReport(){
        let report = Report(uuid: UUID(), week: 0, totalRightTime: 0, totalWrongTime: 0, mostWrongTimeMeal: nil)
        
        ReportDAO.shared.create(report: report) { _ in
            
            return
        }
    }
    
    /// Description: Verify if is the first time launch the app
    /// - Returns: return the status of the first time
    func verifyFirstLaunch() -> Bool{
        
        if !UserDefaults.standard.bool(forKey: "appFirstLaunch"){
            UserDefaults.standard.set(false, forKey: "appFirstLaunch")
            return true
        }
        return false
    }
    
    /// Description: update the meals status in background
    func scheduleNewMealStatus() {
        
        let date = DateManager().setUpDate(hour: 0, minute: 0)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: tomorrow, userInfo: nil) { (error) in
            if let error = error {
                print("Error occurred while scheduling background refresh: \(error.localizedDescription)")
            }
        }
    }
    
    /// Description: Set meal status to 'notTimeYet' in all meals in Core Data
    func resetMeals() {
        MealDAO.shared.retrieve { (meals) in
            guard let meals = meals else { return }
            var updatedMeals: [Meal] = []
            meals.forEach {
                var updatedMeal = $0
                updatedMeal.status = MealStatus.notTimeYet
                updatedMeals.append(updatedMeal)
            }
            updateThis(meals: updatedMeals)
            print("all meals updated in background")
        }
    }
    
    /// Description: Uptade meals in Core Data
    /// - Parameter meals: Meals that will be updated
    func updateThis(meals: [Meal]) {
        meals.forEach {
            MealDAO.shared.update(meal: $0) { _ in }
        }
    }
    
}
