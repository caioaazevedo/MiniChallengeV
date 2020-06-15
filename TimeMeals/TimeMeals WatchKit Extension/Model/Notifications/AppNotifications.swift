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
    
    func sendNotifications(meal: Meal, delay: Int) {
        
        checkAuthorization { (authorized) in
            guard authorized else { return }
            
            print("authorized")
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: meal.title, arguments: nil)
            content.subtitle = NSString.localizedUserNotificationString(forKey: self.dateFormated(date: meal.time), arguments: nil)
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    // Handle any errors
                    print(("Error: \(theError)"))
                }
                
                print("notify")
            }
        }
        
    }
    
    func sendDynamicNotification(meal: Meal) {
        checkAuthorization { (authorized) in
            guard authorized else { return }
            
            print("authorized")
            
            let notification = UNMutableNotificationContent()
            notification.categoryIdentifier = "myCategory"
            notification.title = meal.title
            notification.sound = UNNotificationSound.default
            
            // Configure the recurring date.
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            dateComponents.calendar = calendar
            
//            dateComponents.hour = calendar.component(.hour, from: meal.time)
//            dateComponents.minute = calendar.component(.minute, from: meal.time)
            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "", content: notification, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    // Handle any errors
                    print(("Error: \(theError)"))
                }
                
                print("notify")
            }
        }
    }
    
    func dateFormated(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
