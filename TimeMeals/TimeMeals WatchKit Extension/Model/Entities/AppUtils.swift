//
//  AppUtils.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 18/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

struct AppUtils {
    var firstTimeInTheApp: Date
    /// To Schedule a Notification Request
    var expectedTimeDelay: Date? = nil
    /// The instant the app went into suspended status
    var applicationSuspendedTime: Date? = nil
}
