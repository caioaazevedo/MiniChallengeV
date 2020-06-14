//
//  Time.swift
//  TimeMeals WatchKit Extension
//
//  Created by Luan Cabral on 14/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation


class Time:Equatable,Comparable{
    
    init(_ date: Date) {
        //get user calendar
        let calendar = Calendar.current
        
        //define componensts. Just hour and minute
        let dateComponentes = calendar.dateComponents([.hour,.minute], from: date)
        
        //calculate the begining of the day in secs
        let dateSeconds = dateComponentes.hour! * 3600 + dateComponentes.minute! * 60
        secondsDayBegining = dateSeconds
        hour = dateComponentes.hour!
        minute = dateComponentes.minute!
        
        
    }
    var hour:Int
    var minute:Int
    private let secondsDayBegining:Int
    var date:Date{
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return calendar.date(byAdding: dateComponents, to: Date())!
    }
    
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsDayBegining == rhs.secondsDayBegining
    }
    
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsDayBegining < rhs.secondsDayBegining
    }
    
    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsDayBegining > rhs.secondsDayBegining
    }
    
    
    
}
