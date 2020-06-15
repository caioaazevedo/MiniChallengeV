//
//  IntExtension.swift
//  TimeMeals WatchKit Extension
//
//  Created by Jonatas Coutinho de Faria on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

extension Int{
    
    func timeFormat() -> String{
       return self < 10 ? "0\(String(self))" : String(self)
    }
}
