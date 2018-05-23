//
//  StringExtensions.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 5/22/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation


extension String {
    
    //Convert string to date
    func convertStringToDate(dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
