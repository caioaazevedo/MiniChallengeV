//
//  AppNotifications.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 13/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation
import UserNotifications

class AppNotification: NSObject{
    let notificationCenter = UNUserNotificationCenter.current()
    
    /// Description: request the user authorization to send notifications
    func requestAuthorization(){
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { (authorized, error) in
            if authorized {
                print("User Authorized")
            } else {
                print("User not authorized")
            }
            
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    /// Description: check if the user authorized send notifications
    /// - Parameter completion: return a boolean in case of success or failure
    func checkAuthorization(completion: @escaping (Bool) -> Void){
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                print("Notifications not Authorized")
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    /// Description: sendo notification with delay
    /// - Parameters:
    ///   - meal: the meal information for notification data
    ///   - delay: the ttime delay of the notification
    func sendNotifications(meal: Meal, delay: Int) {
        
        checkAuthorization { (authorized) in
            guard authorized else { return }
            
            print("authorized")
            
            let delayTime = TimeInterval(delay * 60) // add * 60 - to convert to minutes
            
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = "delayNotification"
            content.title = NSString.localizedUserNotificationString(forKey: meal.title, arguments: nil)
            content.subtitle = NSString.localizedUserNotificationString(forKey: self.dateFormated(date: meal.time.addingTimeInterval(delayTime)), arguments: nil)
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delayTime, repeats: false)
            let request = UNNotificationRequest(identifier: "\(meal.uuid.uuidString)Delay", content: content, trigger: trigger) // Schedule the notification.
            self.notificationCenter.add(request) { (error : Error?) in
                if let theError = error {
                    // Handle any errors
                    print(("Error: \(theError)"))
                }
                
                print("notify")
            }
        }
        
    }
    
    ///Description: The notification to send week report
    func sendReportNotification() {
        checkAuthorization { (authorized) in
            guard authorized else { return }
            print("authorized")
            
            let notification = UNMutableNotificationContent()
            notification.categoryIdentifier = "reportNotification"
            notification.title = NSString.localizedUserNotificationString(forKey: "Report", arguments: nil)
            notification.sound = .default
            
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            dateComponents.calendar = calendar
            
            dateComponents.weekday = 7
            dateComponents.hour = 9
            dateComponents.minute = 0
            
            let reportMetrics = ReportMetrics()
            
            reportMetrics.atualReport { (report) in
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: "\(report.uuid.uuidString)", content: notification, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
                    if let err = error {
                        print("Error : \(err)")
                    }
                    print("notify")
                }
            }
            
            
        }
    }
    
    /// Description: the dynamic notification to remember the user every day
    /// - Parameter meal: the meal information for notification data
    func sendDynamicNotification(meal: Meal) {
        checkAuthorization { (authorized) in
            guard authorized else { return }
            
            print("authorized")
            
            let notification = UNMutableNotificationContent()
            notification.categoryIdentifier = "myCategory"
            notification.title = NSString.localizedUserNotificationString(forKey: meal.title, arguments: nil)
            notification.subtitle = NSString.localizedUserNotificationString(forKey: self.dateFormated(date: meal.time), arguments: nil)
            notification.sound = UNNotificationSound.default
            
            // Configure the recurring date.
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            dateComponents.calendar = calendar
            
            
            
            dateComponents.hour = calendar.component(.hour, from: meal.time)
            dateComponents.minute = calendar.component(.minute, from: meal.time)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Uncomment this line to test
            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: meal.uuid.uuidString, content: notification, trigger: trigger)
            
            self.notificationCenter.add(request) { (error : Error?) in
                if let theError = error {
                    // Handle any errors
                    print(("Error: \(theError)"))
                }
                
                print("notify")
            }
        }
    }
    
    /// Description: Function to remove a notification
    /// - Parameter identifier: notification identifier
    func removeNotification(identifier: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    /// Description: format a date
    /// - Parameter date: the date to format
    /// - Returns: the hours and minutes of the date as String
    func dateFormated(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
