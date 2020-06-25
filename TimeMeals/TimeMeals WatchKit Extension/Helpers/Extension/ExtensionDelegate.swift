//
//  ExtensionDelegate.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if  verifyFirstLaunch(){
//            
//            self.createDefaultMeal()
            self.createFirstReport()
            
            AppUtilsDAO.shared.createAppUtils {
                print("create utils")
            }
            
            AppNotification().requestAuthorization()
        }
        scheduleNewMealStatusInBackground()
        scheduleNewMealStatusInForeground()
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
                checkAsyncSchedule()
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
            UserDefaults.standard.set(true, forKey: "appFirstLaunch")
            return true
        }
        return false
    }
    
    /// Description: schedule to update the meals status in background
    func scheduleNewMealStatusInBackground() {
        
        let date = DateManager().setUpDate(hour: 0, minute: 0)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: tomorrow, userInfo: nil) { (error) in
            if let error = error {
                print("Error occurred while scheduling background refresh: \(error.localizedDescription)")
            }
        }
    }
    
    /// Description: Set meal status to 'notTimeYet' in all meals in Core Data
    @objc func resetMeals() {
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
    
    /// Description: checks the need to fetch the meal without notification created
    func checkAsyncSchedule(){
        AppUtilsDAO.shared.retrieve { (retrieve) in
            guard let appUtils = retrieve else { return }
            
            /// Noification not scheduled
            if appUtils.expectedTimeDelay == nil {
                
                // Retrieve the data of the meals and pending notifications
                MealDAO.shared.retrieve { (retrieve) in
                    guard let meals = retrieve else { return }
                    
                    AppNotification().notificationCenter.getPendingNotificationRequests { (requests) in
                        
                        
                        self.scheduleNotification(meals: meals, requests: requests)
                    }
                }
            }
            
            print("Deleay CD: \(String(describing: appUtils.expectedTimeDelay))")
        }
    }
    
    /// Description: Uptade meals in Core Data
    /// - Parameter meals: Meals that will be updated
    func updateThis(meals: [Meal]) {
        meals.forEach {
            MealDAO.shared.update(meal: $0) { _ in }
        }
    }
    
    /// Description: schedule to update the meals status in foreground
    func scheduleNewMealStatusInForeground() {
        let date = DateManager().setUpDate(hour: 0, minute: 0)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        let timer = Timer(fireAt: tomorrow, interval: 0, target: self, selector: #selector(resetMeals), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    /// Description: Find the meals without a notification
    /// - Parameters:
    ///   - meals: meals array o verify the missed notificatiion
    ///   - requests: requests array of pending notifications
    func scheduleNotification(meals: [Meal], requests: [UNNotificationRequest]) {
        var hasNotification = false
        
        for meal in meals {
            for request in requests {
                if meal.uuid.uuidString == request.identifier {
                    hasNotification = true
                }
            }
            
            // If any of the request array matches the meals identifier, than create a notification
            if !hasNotification {
                AppNotification().sendDynamicNotification(meal: meal)
            }
            
            hasNotification = false
        }
    }
}
