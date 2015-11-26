//
//  extension.swift
//  This is the file that contains all the extensions of the
//  default classes
//
//  Created by Diwas  Timilsina on 6/11/15.
//  Copyright (c) 2015 Diwas Timilsina. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        
        if let regex = NSRegularExpression(pattern: leadingAndTrailingWhitespacePattern, options: .CaseInsensitive, error: nil) {
            let range = NSMakeRange(0, count(self))
            let trimmedString = regex.stringByReplacingMatchesInString(self, options: .ReportProgress, range:range, withTemplate:"$1")
            
            return trimmedString
        } else {
            return self
        }
    }
}


extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}


// enstension for arry to include find
extension Array {
    func indexesOf<T : Equatable>(object:T) -> Int {
        var result: [Int] = []
        for (index,obj) in enumerate(self) {
            if obj as! T == object {
                return index
            }
        }
        return -1
    }
}