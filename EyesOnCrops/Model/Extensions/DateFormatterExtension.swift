//
//  DateFormatterExtension.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 5/22/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation

extension String {
    
    //change one date format to another
    func changeDateFormat(date: String, oldFormat: String, newFormat: String = "MMM dd,yyyy") -> String?{
   
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = oldFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = newFormat
        
        if let convertedDate = dateFormatterGet.date(from: date) {
            return dateFormatter.string(from: convertedDate)
        }
        
        return nil
       
    }
}


/*
 
 1. NATURAL LANG PROCESSING
 2. SPEECH PROCESSING
 3. MACHINE LEARNING
 4. DEEP LEARNING
 5. VOICE RECOGNITION
 6.
 
 */
