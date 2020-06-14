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
    
    func sendNotifications() {
        
        checkAuthorization { (authorized) in
            guard authorized else { return }
            
            print("authorized")
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Café da Manhã", arguments: nil)
            content.subtitle = NSString.localizedUserNotificationString(forKey: "7:00", arguments: nil)
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
    
}
